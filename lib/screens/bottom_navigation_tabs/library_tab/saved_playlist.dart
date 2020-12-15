import 'package:flutter/material.dart';

import '../../../common_widgets/workout/create_new_workout_widget.dart';
import '../../../constants.dart';
import '../../../forms/new_playlist/edit_playlist_title.dart';
import '../../details/workout_detail_screen.dart';

class SavedPlaylist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          CreateNewWorkoutWidget(
            '새로운 루틴 추가',
            () {
              Navigator.of(context).pushNamed(EditPlaylistTitle.routeName);
            },
          ),
          SizedBox(height: 4),
          ListView.builder(
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => _buildListItem(context, index),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Hero(
          tag: 'heroTag$index',
          child: Container(
            width: 56,
            height: 56,
            child: Image.asset('images/place_holder_workout_playlist.png'),
          ),
        ),
        title: Text(
          'Playlist title',
          style: BodyText1Bold,
        ),
        subtitle: Text(
          'by Me',
          style: BodyText2Light,
        ),
        onTap: () {
          Navigator.of(context).pushNamed(WorkoutDetailScreen.routeName);
        },
        onLongPress: () {},
      ),
    );
  }
}
