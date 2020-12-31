import 'package:flutter/material.dart';

class MiniplayerExpanded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaq = MediaQuery.of(context);

    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 18),
              alignment: Alignment.center,
              child: Text(
                '월요일 아침 운동',
                style: theme.textTheme.bodyText2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 4, right: 4),
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.expand_more_rounded),
                onPressed: () {},
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: theme.primaryColor,
              ),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              height: 88,
              width: mediaq.size.width,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '00:35:35',
                  style: theme.textTheme.headline1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 21),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.expand_more_rounded),
          onPressed: () {},
          iconSize: 48,
        ),
        SizedBox(height: 33),
        Container(
          margin: EdgeInsets.only(left: 16),
          alignment: Alignment.topLeft,
          child: Text(
            'Current Workout',
            style: theme.textTheme.caption,
          ),
        ),
        Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Color(0xff48484A),
          margin: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '스쿼트',
                          style: theme.textTheme.headline2,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'Warm Up 세트 1',
                          style: theme.textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16, top: 16),
                    child: Row(
                      children: [
                        Text(
                          '999kg',
                          style: theme.textTheme.headline2,
                        ),
                        SizedBox(width: 16),
                        Text(
                          'x',
                          style: theme.textTheme.subtitle1,
                        ),
                        SizedBox(width: 16),
                        Text(
                          '99번',
                          style: theme.textTheme.headline2,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
              Positioned(
                top: 44,
                right: 16,
                child: IconButton(
                  icon: Icon(Icons.done_rounded),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
