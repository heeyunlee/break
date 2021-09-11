import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/youtube_video.dart';
import 'package:workout_player/services/algolia_manager.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/screens/watch_tab.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'library/workout_detail_screen.dart';
import 'workouts_by_category_scree.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final locale = Intl.getCurrentLocale();

  late FloatingSearchBarController _controller;
  // TODO: Extract search model HERE
  AlgoliaIndexReference algoliaIndexReference =
      AlgoliaManager().initAlgolia().instance.index('prod_WORKOUTS');
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

  Future<void> onQueryChanged(String query) async {
    if (query.isNotEmpty) {
      _isLoading = true;
      final algoliaQuery = algoliaIndexReference.query(query);

      final snapshot = await algoliaQuery.getObjects();
      final result = snapshot.hits;
      setState(() {
        _isLoading = false;
        searchResults = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[ExploreTab] building...');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: kAppBarColor,
          elevation: 0,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: FloatingSearchBar(
        controller: _controller,
        iconColor: Colors.black,
        automaticallyImplyBackButton: false,
        borderRadius: BorderRadius.circular(24),
        transitionDuration: const Duration(milliseconds: 300),
        debounceDelay: const Duration(milliseconds: 300),
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        width: size.width - 32,
        progress: _isLoading,
        transitionCurve: Curves.easeInOut,
        hint: S.current.searchBarHintText,
        hintStyle: TextStyles.body2Grey,
        backdropColor: kAppBarColor,
        backgroundColor: Colors.white,
        queryStyle: TextStyles.body2Black,
        actions: [
          const FloatingSearchBarAction(
            child: Icon(Icons.fitness_center_outlined),
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
              child: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ],
        transition: CircularFloatingSearchBarTransition(),
        onQueryChanged: onQueryChanged,
        onSubmitted: onQueryChanged,
        body: FloatingSearchBarScrollNotifier(child: _buildBody()),
        builder: (context, transition) => (searchResults.isEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),
                  SvgPicture.asset(
                    'assets/images/people_working_out.svg',
                    width: 200,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    S.current.searchResultsEmptyText,
                    style: TextStyles.body1,
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: searchResults.map((e) {
                    final data = e.data;
                    final workoutId = data['workoutId'].toString();

                    final title = data['translated'][locale].toString();

                    final muscle = MainMuscleGroup.values
                        .firstWhere(
                          (e) => e.toString() == data['mainMuscleGroup'][0],
                        )
                        .translation!;

                    final equipment = EquipmentRequired.values
                        .firstWhere(
                          (e) => e.toString() == data['equipmentRequired'][0],
                        )
                        .translation!;

                    return SearchResultListTile(
                      title: title,
                      subtitle:
                          S.current.searchResultSubtitle(muscle, equipment),
                      onTap: () async {
                        // _controller.close();
                        await WorkoutDetailScreen.show(
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

  Widget _buildBody() {
    final database = Provider.of<Database>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 96),
          Row(
            children: [
              const SizedBox(width: 24),
              Text(
                S.current.workouts,
                style: TextStyles.body1W800,
              ),
              const Spacer(),
              InkWell(
                onTap: () => WorkoutsByCategoryScreen.show(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.seeMore,
                    style: TextStyles.button1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const WorkoutsByCategoryCard(),
          const SizedBox(height: 40),
          Row(
            children: [
              const SizedBox(width: 24),
              Text(
                S.current.workoutWithYoutube,
                style: TextStyles.body1W800,
              ),
              const Spacer(),
              InkWell(
                onTap: () => WatchTab.show(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.current.seeMore,
                    style: TextStyles.button1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          CustomStreamBuilder<List<YoutubeVideo>>(
            stream: database.youtubeVideosStream(),
            builder: (context, videos) {
              return SizedBox(
                height: 280,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: videos.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return YoutubeVideoCard(
                      height: 200,
                      width: size.width - 80,
                      heroTag: videos[index].youtubeVideoId,
                      youtubeVideo: videos[index],
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}
