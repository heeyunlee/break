import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class AddProteinScreen extends StatefulWidget {
  final User user;
  final Database database;
  final AuthBase auth;

  const AddProteinScreen({
    Key? key,
    required this.user,
    required this.database,
    required this.auth,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddProteinScreen(
          user: user,
          database: database,
          auth: auth,
        ),
      ),
    );
    // await pushNewScreen(
    //   context,
    //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
    //   withNavBar: false,
    //   screen: AddProteinScreen(
    //     database: database,
    //     user: user!,
    //     auth: auth,
    //   ),
    // );
  }

  @override
  _AddProteinScreenState createState() => _AddProteinScreenState();
}

class _AddProteinScreenState extends State<AddProteinScreen> {
  late Timestamp _loggedTime;
  late String _loggedTimeInString;
  late DateTime _loggedDate;

  int _intValue = 25;
  int _decimalValue = 0;
  late double _proteinAmount;
  final List<String> _meals = Meal.values[0].list;
  final List<String> _mealsTranslated = Meal.values[0].translatedList;
  int? _selectedIndex;
  String? _mealType;

  String? get _notes => _textController1.text;
  late FocusNode focusNode1;
  late TextEditingController _textController1;

  @override
  void initState() {
    super.initState();
    _loggedTime = Timestamp.now();
    _loggedTimeInString = Format.yMdjmInDateTime(_loggedTime.toDate());
    final nowInDate = _loggedTime.toDate();
    _loggedDate = DateTime.utc(nowInDate.year, nowInDate.month, nowInDate.day);

    _proteinAmount = _intValue + _decimalValue * 0.1;

    _textController1 = TextEditingController();
    focusNode1 = FocusNode();
  }

  @override
  void dispose() {
    _textController1.dispose();
    focusNode1.dispose();
    super.dispose();
  }

  // Submit data to Firestore
  Future<void> _submit() async {
    if (_mealType != null) {
      debugPrint('submit Button Pressed!');
      try {
        // Create new Nutrition Data
        final id = 'NUT${documentIdFromCurrentDate()}';

        final nutrition = Nutrition(
          nutritionId: id,
          userId: widget.auth.currentUser!.uid,
          username: widget.user.userName,
          loggedTime: _loggedTime,
          loggedDate: _loggedDate,
          proteinAmount: _proteinAmount,
          type: _mealType!,
          notes: _notes,
        );

        // Update User data
        final nutritions = widget.user.dailyNutritionHistories;

        final index = widget.user.dailyNutritionHistories!
            .indexWhere((element) => element.date.toUtc() == _loggedDate);

        if (index == -1) {
          // create new nutrition data if not exists
          final newNutrition = DailyNutritionHistory(
            date: _loggedDate,
            totalProteins: _proteinAmount,
          );
          nutritions!.add(newNutrition);
        } else {
          // Update nutrition data if exists
          final oldNutrition = nutritions![index];

          final newNutrition = DailyNutritionHistory(
            date: oldNutrition.date,
            totalProteins: oldNutrition.totalProteins + _proteinAmount,
          );
          nutritions[index] = newNutrition;
        }

        final user = {
          'dailyNutritionHistories': nutritions.map((e) => e.toMap()).toList(),
        };

        // Call Firebase
        await widget.database.setNutrition(nutrition);
        await widget.database.updateUser(widget.auth.currentUser!.uid, user);
        Navigator.of(context).pop();

        // TODO: Fix Snackbar here
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.current.addProteinEntrySnackbar),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ));
      } on FirebaseException catch (e) {
        logger.d(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.selectMealTypeAlertTitle,
        content: S.current.selectMeapTypeAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  void _showDatePicker(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: CardColorLight,
          height: size.height / 3,
          child: CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              initialDateTime: _loggedTime.toDate(),
              onDateTimeChanged: (value) => setState(() {
                _loggedTime = Timestamp.fromDate(value);
                _loggedTimeInString = Format.yMdjmInDateTime(
                  _loggedTime.toDate(),
                );
                _loggedDate = DateTime.utc(value.year, value.month, value.day);
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
        backgroundColor: AppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        title: Text(S.current.addProteins, style: Subtitle2),
      ),
      body: _buildBody(),
      floatingActionButton: Container(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: _submit,
          backgroundColor: PrimaryColor,
          heroTag: 'addProteinButton',
          label: Text(S.current.submit),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Theme(
      data: ThemeData(
        primaryColor: PrimaryColor,
        disabledColor: Colors.grey,
        iconTheme: IconTheme.of(context).copyWith(color: Colors.white),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(S.current.time, style: BodyText1w800),
              ),
              GestureDetector(
                onTap: () => _showDatePicker(context),
                child: Card(
                  color: CardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _loggedTimeInString,
                          style: BodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(S.current.amount, style: BodyText1w800),
              ),
              Card(
                color: CardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberPicker(
                        minValue: 1,
                        maxValue: 100,
                        itemHeight: 36,
                        textStyle: BodyText1,
                        selectedTextStyle: Headline5w900Primary,
                        value: _intValue,
                        onChanged: (value) => setState(
                          () {
                            HapticFeedback.mediumImpact();
                            _intValue = value;
                            _proteinAmount = _intValue + _decimalValue * 0.1;
                          },
                        ),
                      ),
                      const Text('.', style: Headline5w900Primary),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 9,
                        itemHeight: 36,
                        textStyle: BodyText1,
                        selectedTextStyle: Headline5w900Primary,
                        value: _decimalValue,
                        onChanged: (value) => setState(
                          () {
                            HapticFeedback.mediumImpact();
                            _decimalValue = value;
                            _proteinAmount = _intValue + _decimalValue * 0.1;
                          },
                        ),
                      ),
                      const Text('g', style: BodyText1),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(S.current.mealType, style: BodyText1w800),
              ),
              _buildType(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(S.current.notes, style: BodyText1w800),
              ),
              Card(
                color: CardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextFormField(
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    controller: _textController1,
                    style: BodyText2,
                    focusNode: focusNode1,
                    decoration: InputDecoration(
                      hintText: S.current.addNotes,
                      hintStyle: BodyText2Grey,
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: (value) => setState(() {}),
                    onChanged: (value) => setState(() {}),
                    onSaved: (value) => setState(() {}),
                  ),
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildType() {
    final List<Widget> chips = [];

    chips.add(SizedBox(width: 12));
    for (var i = 0; i < _meals.length; i++) {
      var choiceChip = ChoiceChip(
        shape: StadiumBorder(
          side: BorderSide(
              color: (_selectedIndex == i) ? Primary300Color : Colors.grey,
              width: 1),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8),
        label: Text(_mealsTranslated[i], style: ButtonText),
        selected: _selectedIndex == i,
        selectedShadowColor: PrimaryColor,
        backgroundColor: BackgroundColor,
        selectedColor: PrimaryColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
              _mealType = _meals[i];
            }
            debugPrint(_mealType);
          });
        },
      );

      chips.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: choiceChip,
        ),
      );
    }
    chips.add(SizedBox(width: 12));

    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips,
      ),
    );
  }
}
