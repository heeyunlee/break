import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/services/algolia_manager.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'search_category_screen.dart';
import 'workout_detail_screen.dart';

class ExploreTab extends ConsumerStatefulWidget {
  const ExploreTab({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<ExploreTab> {
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
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          elevation: 0,
        ),
      ),
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
        backdropColor: theme.backgroundColor,
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
                        WorkoutDetailScreen.show(
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
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 96),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              S.current.workoutsAndRoutinesByCategory,
              style: TextStyles.headline6Bold,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.mainMuscleGroup,
              style: TextStyles.body1W900Menlo,
            ),
          ),
          GridView.count(
            childAspectRatio: 2.5,
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: MainMuscleGroup.values.map(
              (muscle) {
                return SearchCategoryWidget(
                  color: theme.primaryColor,
                  text: muscle.translation!,
                  onTap: () => SearchCategoryScreen.show(
                    context,
                    arrayContains: muscle.toString(),
                    searchCategory: 'mainMuscleGroup',
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.equipmentRequired,
              style: TextStyles.body1W900Menlo,
            ),
          ),
          GridView.count(
            childAspectRatio: 2.5,
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: EquipmentRequired.values.map(
              (equipment) {
                return SearchCategoryWidget(
                  color: theme.colorScheme.secondary,
                  text: equipment.translation!,
                  onTap: () => SearchCategoryScreen.show(
                    context,
                    arrayContains: equipment.toString(),
                    searchCategory: 'equipmentRequired',
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              S.current.equipmentRequired,
              style: TextStyles.body1W900Menlo,
            ),
          ),
          GridView.count(
            childAspectRatio: 2.5,
            crossAxisCount: 2,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: Location.values.map(
              (location) {
                return SearchCategoryWidget(
                  color: Colors.amber,
                  text: location.translation!,
                  onTap: () => SearchCategoryScreen.show(
                    context,
                    searchCategory: 'location',
                    isEqualTo: location.toString(),
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: kBottomNavigationBarHeight + 40),
          // Row(
          //   children: [
          //     const SizedBox(width: 24),
          //     Text(
          //       S.current.workouts,
          //       style: TextStyles.body1W800,
          //     ),
          //     const Spacer(),
          //     InkWell(
          //       onTap: () => WorkoutsByCategoryScreen.show(context),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text(
          //           S.current.seeMore,
          //           style: TextStyles.button1,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //   ],
          // ),
          // const WorkoutsByCategoryCard(),
          // const SizedBox(height: 40),
          // Row(
          //   children: [
          //     const SizedBox(width: 24),
          //     Text(
          //       S.current.workoutWithYoutube,
          //       style: TextStyles.body1W800,
          //     ),
          //     const Spacer(),
          //     InkWell(
          //       onTap: () => WatchTab.show(context),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Text(
          //           S.current.seeMore,
          //           style: TextStyles.button1,
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //   ],
          // ),
          // CustomStreamBuilder<List<YoutubeVideo>>(
          //   stream: database.youtubeVideosStream(),
          //   builder: (context, videos) {
          //     return SizedBox(
          //       height: 280,
          //       child: ListView.builder(
          //         padding: EdgeInsets.zero,
          //         itemCount: videos.length,
          //         scrollDirection: Axis.horizontal,
          //         itemBuilder: (context, index) {
          //           return YoutubeVideoCard(
          //             height: 200,
          //             width: size.width - 80,
          //             heroTag: videos[index].youtubeVideoId,
          //             youtubeVideo: videos[index],
          //           );
          //         },
          //       ),
          //     );
          //   },
          // ),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}
