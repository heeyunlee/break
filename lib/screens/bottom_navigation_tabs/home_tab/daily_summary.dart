import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../constants.dart';
import '../../../screens/cardio_entry/cardio_entry_screen.dart';
import '../../../screens/protein_entry/protein_entry_screen.dart';
import '../search_tab/search_tab.dart';

class _workoutEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Text(
          'Rock On!',
          textAlign: TextAlign.center,
          style: BodyText2,
          maxLines: 2,
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WeightEntry(),
            CardioEntry(),
            ProteinEntry(),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}

class WeightEntry extends StatefulWidget {
  @override
  _WeightEntryState createState() => _WeightEntryState();
}

class _WeightEntryState extends State<WeightEntry> {
  bool _isWeightAdded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isWeightAdded == false
            ? Container(
                height: 64,
                width: 64,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        duration: Duration(milliseconds: 250),
                        child: SearchTab(),
                        type: PageTransitionType.bottomToTop,
                      ),
                    );
                    // setState(() {
                    //   _isWeightAdded = !_isWeightAdded;
                    // });
                  },
                ),
              )
            : Image.asset(
                'images/weights.png',
                width: 64,
                height: 64,
              ),
        SizedBox(height: 19),
        Text(
          '웨이트',
          style: BodyText2,
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  2,
                ),
              ),
            ),
            _isWeightAdded == false
                ? Container()
                : Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(
                        2,
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '0/ 0 kg',
          style: Caption1,
        ),
      ],
    );
  }
}

class CardioEntry extends StatefulWidget {
  @override
  _CardioEntryState createState() => _CardioEntryState();
}

class _CardioEntryState extends State<CardioEntry> {
  bool _isCardioAdded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isCardioAdded == false
            ? Container(
                height: 64,
                width: 64,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CardioEntryScreen.routeName);
                    //   context,
                    //   PageTransition(
                    //     duration: Duration(milliseconds: 250),
                    //     child: CardioEntryScreen(),
                    //     type: PageTransitionType.bottomToTop,
                    //   ),
                    // );

                    // Uncomment after building CardioEntryScreen()

                    // setState(() {
                    //   _isCardioAdded = !_isCardioAdded;
                    // });
                  },
                ),
              )
            : Image.asset(
                'images/cardio.png',
                height: 64,
                width: 64,
              ),
        SizedBox(height: 19),
        Text(
          '유산소',
          style: BodyText2,
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  2,
                ),
              ),
            ),
            _isCardioAdded == false
                ? Container()
                : Container(
                    height: 4,
                    width: 90,
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(
                        2,
                      ),
                    ),
                  )
          ],
        ),
        SizedBox(height: 8),
        Text(
          '0 / 0 Kcal',
          style: Caption1,
        ),
      ],
    );
  }
}

class ProteinEntry extends StatefulWidget {
  @override
  _ProteinEntryState createState() => _ProteinEntryState();
}

class _ProteinEntryState extends State<ProteinEntry> {
  bool _isProteinAdded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isProteinAdded == false
            ? Container(
                height: 64,
                width: 64,
                child: IconButton(
                  icon: Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, ProteinEntryScreen.routeName);
                    //   context,
                    //   PageTransition(
                    //     duration: Duration(milliseconds: 250),
                    //     child: ProteinEntryScreen(),
                    //     type: PageTransitionType.bottomToTop,
                    //   ),
                    // );
                    // setState(() {
                    //   _isProteinAdded = !_isProteinAdded;
                    // });
                  },
                ),
              )
            : Image.asset(
                'images/steak.png',
                height: 64,
                width: 64,
              ),
        SizedBox(height: 19),
        Text(
          '단백질',
          style: BodyText2,
        ),
        SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(
                  2,
                ),
              ),
            ),
            _isProteinAdded == false
                ? Container()
                : Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(
                        2,
                      ),
                    ),
                  )
          ],
        ),
        SizedBox(height: 8),
        Text(
          '0 / 0 g',
          style: Caption1,
        ),
      ],
    );
  }
}

class DailyWorkoutSummary extends StatelessWidget {
  final String title;
  final String date;

  DailyWorkoutSummary(
    @required this.title,
    @required this.date,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: BodyText2),
              Text(date, style: BodyText2),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 240,
          child: Card(
            color: CardColor,
            margin: EdgeInsets.only(left: 16, right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 1,
            child: _workoutEntry(),
          ),
        ),
      ],
    );
  }
}
