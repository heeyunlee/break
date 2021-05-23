import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shimmer/shimmer.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/progress_tab/flexible_space_tablet.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../constants.dart';
import '../../dummy_data.dart';
import '../../format.dart';
import 'measurement/measurements_line_chart_widget.dart';
import 'proteins_eaten/proteins_eaten_chart_widget.dart';
import 'weights_lifted_history/weights_lifted_chart_widget.dart';

// final StreamController<User> _currentUserStreamCtrl =
//     StreamController<User>.broadcast();
// Stream<User> get onCurrentUserChanged => _currentUserStreamCtrl.stream;

class ProgressTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final uid = watch(authServiceProvider).currentUser!.uid;
    final stream = watch(userStreamProvider(uid));

    debugPrint('Progress Tab scaffold building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: stream.when(
        data: (user) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              brightness: Brightness.dark,
              flexibleSpace: _FlexibleSpaceMobile(user: user),
              backgroundColor: kAppBarColor,
              elevation: 0,
            ),
            _buildSliverToBoxAdaptor(user!),
          ],
        ),
        loading: () => ProgressTabShimmer(),
        error: (e, stack) => EmptyContent(),
      ),
    );
  }

  Widget _buildSliverToBoxAdaptor(User user) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WeightsLiftedChartWidget(user: user),
            ProteinsEatenChartWidget(user: user),
            MeasurementsLineChartWidget(user: user),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}

class _FlexibleSpaceMobile extends StatelessWidget {
  final User? user;

  const _FlexibleSpaceMobile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final weights = Format.weights(user!.totalWeights);
    final unit = Format.unitOfMass(user!.unitOfMass);

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
              Text(user!.displayName, style: kSubtitle1w900),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: kPrimaryColor,
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
                      RichText(
                        text: TextSpan(
                          text: weights,
                          style: GoogleFonts.blackHanSans(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '  $unit', style: kBodyText1),
                          ],
                        ),
                      ),
                      Text(S.current.lifted, style: kBodyText1),
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
