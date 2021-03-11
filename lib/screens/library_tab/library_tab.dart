import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/sliver_app_bar_delegate.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings/settings_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import '../../format.dart';
import 'activity/saved_routine_histories_tab.dart';
import 'routine/saved_routines_tab.dart';
import 'workout/saved_workouts_tab.dart';

class LibraryTab extends StatelessWidget {
  static const routeName = 'library';

  @override
  Widget build(BuildContext context) {
    debugPrint('LibraryTab scaffold building...');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _buildSliverAppBar(context),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: SliverAppBarDelegate(
                  const TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: PrimaryColor,
                    indicatorColor: PrimaryColor,
                    tabs: [
                      Tab(text: 'Activities'),
                      Tab(text: 'Routines'),
                      Tab(text: 'Workouts'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SavedRoutineHistoriesTab(),
              SavedRoutinesTab(),
              SavedWorkoutsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings_rounded,
            color: Colors.white,
          ),
          onPressed: () => SettingsScreen.show(context),
        ),
        const SizedBox(width: 8),
      ],
      expandedHeight: 200,
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      flexibleSpace: _FlexibleSpace(),
      backgroundColor: AppBarColor,
      elevation: 0,
    );
  }
}

class _FlexibleSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return FlexibleSpaceBar(
      background: StreamBuilder<User>(
          initialData: userDummyData,
          stream: database.userStream(userId: auth.currentUser.uid),
          builder: (context, snapshot) {
            final size = MediaQuery.of(context).size;

            final user = snapshot.data;

            final weights = Format.weights(user.totalWeights);
            final unit = Format.unitOfMass(user.unitOfMass);
            final numberOfWorkouts = user.totalNumberOfWorkouts;
            final times = (numberOfWorkouts == 0) ? 'time' : 'times';

            return Column(
              children: <Widget>[
                const SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Text(user.userName, style: Subtitle1w900),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  color: PrimaryColor,
                  child: Container(
                    height: size.height / 9,
                    width: size.width - 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text('Total Weights', style: Caption1),
                              const SizedBox(height: 8),
                              Text(
                                '$weights $unit',
                                style: Headline6w900,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          width: 1,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Container(
                          width: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Text('Total Activities', style: Caption1),
                              const SizedBox(height: 8),
                              Text(
                                '$numberOfWorkouts $times',
                                style: Subtitle1w900,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
