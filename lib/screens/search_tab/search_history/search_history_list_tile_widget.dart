import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';

class SearchHistoryListTileWidget extends StatelessWidget {
  final String query;
  final void Function() tileOnTap;
  final void Function() iconOnTap;

  const SearchHistoryListTileWidget({
    Key? key,
    required this.query,
    required this.tileOnTap,
    required this.iconOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.history_rounded, color: Colors.grey),
      title: Text(query, style: kBodyText2Grey),
      onTap: tileOnTap,
      trailing: InkWell(
        onTap: iconOnTap,
        child: Icon(Icons.close_rounded, color: Colors.grey),
      ),
    );
  }
}
