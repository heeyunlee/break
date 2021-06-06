import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/main_provider.dart';

import '../../constants.dart';
import 'search_result/search_result_list_tile.dart';
import 'search_tab_body_widget.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late FloatingSearchBarController _controller;
  AlgoliaIndexReference algoliaIndexReference =
      algolia.instance.index('dev_WORKOUTS');
  List<AlgoliaObjectSnapshot> searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = FloatingSearchBarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onQueryChanged(String query) async {
    _isLoading = true;
    final algoliaQuery = algoliaIndexReference.query(query);
    final snapshot = await algoliaQuery.getObjects();
    final result = snapshot.hits;
    setState(() {
      _isLoading = false;
      searchResults = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d('SearchTab Scaffold building...');

    final size = MediaQuery.of(context).size;
    final locale = Intl.getCurrentLocale();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: kAppBarColor,
          brightness: Brightness.dark,
          elevation: 0,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: FloatingSearchBar(
        controller: _controller,
        clearQueryOnClose: true,
        iconColor: Colors.black,
        automaticallyImplyBackButton: true,
        borderRadius: BorderRadius.circular(24),
        transitionDuration: const Duration(milliseconds: 300),
        debounceDelay: const Duration(milliseconds: 300),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        width: size.width - 32,
        progress: _isLoading,
        transitionCurve: Curves.easeInOut,
        hint: S.current.searchBarHintText,
        hintStyle: kBodyText2Grey,
        backdropColor: kAppBarColor,
        backgroundColor: Colors.white,
        queryStyle: kBodyText2Black,
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: const Icon(Icons.fitness_center_outlined),
          ),
          const SizedBox(width: 8),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        leadingActions: [
          FloatingSearchBarAction(
            showIfOpened: true,
            showIfClosed: false,
            child: GestureDetector(
              onTap: () {
                _controller.close();
                setState(() {
                  searchResults = [];
                });
              },
              child: Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ],
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        // onQueryChanged: onQueryChanged,
        onSubmitted: onQueryChanged,
        body: FloatingSearchBarScrollNotifier(child: SearchTabBodyWidget()),
        builder: (context, transition) => (searchResults.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  SvgPicture.asset(
                    'assets/images/people_working_out_1.svg',
                    width: 200,
                  ),
                  const SizedBox(height: 24),
                  Text(S.current.searchResultsEmptyText, style: kBodyText1),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: searchResults.map((e) {
                    final data = e.data;

                    final title = data['translated'][locale];

                    final muscle = MainMuscleGroup.values
                        .firstWhere(
                            (e) => e.toString() == data['mainMuscleGroup'][0])
                        .translation!;

                    final equipment = EquipmentRequired.values
                        .firstWhere(
                            (e) => e.toString() == data['equipmentRequired'][0])
                        .translation!;

                    final workoutId = data['workoutId'];

                    return SearchResultListTile(
                      title: title,
                      subtitle:
                          S.current.searchResultSubtitle(muscle, equipment),
                      onTap: () {
                        _controller.close();
                        return WorkoutDetailScreen.show(
                          context,
                          workoutId: workoutId,
                          tag: 'workoutSearchTag$workoutId',
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
