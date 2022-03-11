import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/customize_widgets_screen_model.dart';
import 'package:workout_player/view_models/progress_tab_model.dart';

class CustomizeWidgetsScreen extends StatefulWidget {
  final User user;
  final CustomizeWidgetsScreenModel model;

  const CustomizeWidgetsScreen({
    Key? key,
    required this.user,
    required this.model,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required User user,
  }) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) => CustomizeWidgetsScreen(
          user: user,
          model: ref.watch(customizeWidgetsScreenModelProvider),
        ),
      ),
    );
  }

  @override
  _CustomizeWidgetsScreenState createState() => _CustomizeWidgetsScreenState();
}

class _CustomizeWidgetsScreenState extends State<CustomizeWidgetsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // return FutureBuilder<MaterialYouPalette?>(
    //   future: getMaterialYouColor(),
    //   builder: (context, snapshot) {
    //     return Scaffold(
    //       backgroundColor: theme.backgroundColor,
    //       body: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             const SizedBox(height: 120),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade50,
    //               child: const Text('snapshot.data?.accent1.shade50'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade100,
    //               child: const Text('snapshot.data?.accent1.shade100'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade200,
    //               child: const Text('snapshot.data?.accent1.shade200'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade300,
    //               child: const Text('snapshot.data?.accent1.shade300'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade400,
    //               child: const Text('snapshot.data?.accent1.shade400'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade500,
    //               child: const Text('snapshot.data?.accent1.shade500'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade600,
    //               child: const Text('snapshot.data?.accent1.shade600'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade700,
    //               child: const Text('snapshot.data?.accent1.shade700'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade800,
    //               child: const Text('snapshot.data?.accent1.shade800'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent1.shade900,
    //               child: const Text('snapshot.data?.accent1.shade900'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade50,
    //               child: const Text('snapshot.data?.accent2.shade50'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade100,
    //               child: const Text('snapshot.data?.accent2.shade100'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade200,
    //               child: const Text('snapshot.data?.accent2.shade200'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade300,
    //               child: const Text('snapshot.data?.accent2.shade300'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade400,
    //               child: const Text('snapshot.data?.accent2.shade400'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade500,
    //               child: const Text('snapshot.data?.accent2.shade500'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade600,
    //               child: const Text('snapshot.data?.accent2.shade600'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade700,
    //               child: const Text('snapshot.data?.accent2.shade700'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade800,
    //               child: const Text('snapshot.data?.accent2.shade800'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent2.shade900,
    //               child: const Text('snapshot.data?.accent2.shade900'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade50,
    //               child: const Text('snapshot.data?.accent3.shade50'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade100,
    //               child: const Text('snapshot.data?.accent3.shade100'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade200,
    //               child: const Text('snapshot.data?.accent3.shade200'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade300,
    //               child: const Text('snapshot.data?.accent3.shade300'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade400,
    //               child: const Text('snapshot.data?.accent3.shade400'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade500,
    //               child: const Text('snapshot.data?.accent3.shade500'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade600,
    //               child: const Text('snapshot.data?.accent3.shade600'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade700,
    //               child: const Text('snapshot.data?.accent3.shade700'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade800,
    //               child: const Text('snapshot.data?.accent3.shade800'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.accent3.shade900,
    //               child: const Text('snapshot.data?.accent3.shade900'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade50,
    //               child: const Text('snapshot.data?.neutral1.shade50'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade100,
    //               child: const Text('snapshot.data?.neutral1.shade100'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade200,
    //               child: const Text('snapshot.data?.neutral1.shade200'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade300,
    //               child: const Text('snapshot.data?.neutral1.shade300'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade400,
    //               child: const Text('snapshot.data?.neutral1.shade400'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade500,
    //               child: const Text('snapshot.data?.neutral1.shade500'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade600,
    //               child: const Text('snapshot.data?.neutral1.shade600'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade700,
    //               child: const Text('snapshot.data?.neutral1.shade700'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade800,
    //               child: const Text('snapshot.data?.neutral1.shade800'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral1.shade900,
    //               child: const Text('snapshot.data?.neutral1.shade900'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade50,
    //               child: const Text('snapshot.data?.neutral2.shade50'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade100,
    //               child: const Text('snapshot.data?.neutral2.shade100'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade200,
    //               child: const Text('snapshot.data?.neutral2.shade200'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade300,
    //               child: const Text('snapshot.data?.neutral2.shade300'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade400,
    //               child: const Text('snapshot.data?.neutral2.shade400'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade500,
    //               child: const Text('snapshot.data?.neutral2.shade500'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade600,
    //               child: const Text('snapshot.data?.neutral2.shade600'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade700,
    //               child: const Text('snapshot.data?.neutral2.shade700'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade800,
    //               child: const Text('snapshot.data?.neutral2.shade800'),
    //             ),
    //             Container(
    //               width: size.width,
    //               height: 120,
    //               color: snapshot.data?.neutral2.shade900,
    //               child: const Text('snapshot.data?.neutral2.shade900'),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBarCloseButton(),
        title: Text(S.current.addOrRemoveWidgets, style: TextStyles.subtitle2),
      ),
      body: Builder(builder: (context) => _buildBody(context)),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: () => widget.model.submit(context),
          label: Text(S.current.submit, style: TextStyles.button1),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: Scaffold.of(context).appBarMaxHeight! + 16,
          bottom: 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.customizeWidgetsTitle,
                style: TextStyles.subtitle1,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                S.current.customizeWidgetsMessage,
                style: TextStyles.subtitle2Grey,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: size.height / 3,
              child: GridView.count(
                childAspectRatio: 3 / 2,
                crossAxisCount: 1,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                shrinkWrap: true,
                children: [
                  // Card(
                  //   color: kCardColor,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: InkWell(
                  //     onTap: () => widget.model.showModalBottomSheet(context),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(S.current.addPhotos, style: TextStyles.body2),
                  //         const SizedBox(height: 8),
                  //         Icon(
                  //           Icons.add_rounded,
                  //           color: Colors.white,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  ...List.generate(
                    ProgressTabModel.bgURL.length,
                    (index) => GestureDetector(
                      onTap: () => widget.model.setselectedImageIndex(index),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                        color: index == widget.model.selectedImageIndex
                            ? theme.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          side: index == widget.model.selectedImageIndex
                              ? BorderSide(color: theme.primaryColor, width: 2)
                              : BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.antiAlias,
                          fit: StackFit.passthrough,
                          children: [
                            CachedNetworkImage(
                              imageUrl: ProgressTabModel.bgURL[index],
                              placeholder: (context, _) => BlurHash(
                                hash: ProgressTabModel.bgPlaceholderHash[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ...List.generate(
                  //   widget.model.personalImagesUrls.length,
                  //   (index) {
                  //     print('${widget.model.personalImagesUrls.length}');
                  //     return GestureDetector(
                  //       child: Card(
                  //         color: Colors.transparent,
                  //         clipBehavior: Clip.antiAlias,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         child: Stack(
                  //           clipBehavior: Clip.antiAlias,
                  //           fit: StackFit.passthrough,
                  //           children: [
                  //             CachedNetworkImage(
                  //               imageUrl: widget.model.personalImagesUrls[index],
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.model.currentPreviewWidgetList.map(
                  (value) {
                    final key = value.key
                        .toString()
                        .replaceAll(RegExp(r'[^\w\s]+'), '');
                    final hasKey = widget.model.widgetKeysList.contains(key);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Stack(
                        children: [
                          value,
                          Positioned.fill(
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: hasKey
                                    ? Border.all(color: theme.primaryColor)
                                    : Border.all(width: 0),
                                borderRadius: BorderRadius.circular(24),
                                color: hasKey
                                    ? theme.primaryColor.withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () => widget.model.onTap(key),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: hasKey
                                          ? Icon(
                                              Icons
                                                  .check_circle_outline_rounded,
                                              color: theme.primaryColor,
                                              size: 32,
                                            )
                                          : const Icon(
                                              Icons.circle_outlined,
                                              size: 32,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
