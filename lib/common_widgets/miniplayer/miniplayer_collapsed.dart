import 'package:flutter/material.dart';

class MiniplayerCollapsed extends StatefulWidget {
  @override
  _MiniplayerCollapsedState createState() => _MiniplayerCollapsedState();
}

class _MiniplayerCollapsedState extends State<MiniplayerCollapsed> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaq = MediaQuery.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
        bottom: 38,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '스쿼트',
                style: theme.textTheme.headline2,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 11,
              ),
              Text(
                'Warm Up 세트 1',
                style: theme.textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            children: [
              Text(
                '60kg',
                style: theme.textTheme.subtitle2,
              ),
              SizedBox(width: 16),
              Text(
                'x',
                style: theme.textTheme.bodyText2,
              ),
              SizedBox(width: 16),
              Text(
                '10번',
                style: theme.textTheme.subtitle2,
              ),
            ],
          ),
        ],
      ),
      trailing: Container(
        margin: EdgeInsets.only(bottom: 32),
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.pause_rounded),
          onPressed: () {},
        ),
      ),
    );
  }
}
