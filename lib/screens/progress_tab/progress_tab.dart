import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/speed_dial_fab.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/settings/settings_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import '../../dummy_data.dart';
import '../../format.dart';
// import 'weights_history/weights_history_chart_widget.dart';
import 'weights_lifted/weights_lifted_chart_widget.dart';
import 'proteins_eaten/proteins_eaten_chart_widget.dart';

class ProgressTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('Progress Tab scaffold building...');

    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: StreamBuilder<User>(
          initialData: userDummyData,
          stream: database.userStream(auth.currentUser.uid),
          builder: (context, snapshot) {
            final user = snapshot.data;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
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
                  flexibleSpace: _FlexibleSpace(user: user),
                  backgroundColor: AppBarColor,
                  elevation: 0,
                ),
                _buildSliverToBoxAdaptor(user, database),
              ],
            );
          },
        ),
        floatingActionButton: SpeedDialFAB(),
      ),
    );
  }

  Widget _buildSliverToBoxAdaptor(User user, Database database) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeightsLiftedChartWidget(
              database: database,
              user: user,
            ),
            ProteinsEatenChartWidget(user: user),
            // WeightsHistoryChartWidget(),
          ],
        ),
      ),
    );
  }
}

class _FlexibleSpace extends StatelessWidget {
  final User user;

  const _FlexibleSpace({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final weights = Format.weights(user.totalWeights);
    final unit = Format.unitOfMass(user.unitOfMass);

    return FlexibleSpaceBar(
      background: Column(
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: PrimaryColor,
            child: Container(
              height: size.height / 9,
              width: size.width - 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        weights,
                        style: GoogleFonts.blackHanSans(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      Text('$unit Lifted', style: BodyText1),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
