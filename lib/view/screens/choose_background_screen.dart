import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/choose_background_screen_model.dart';
import 'package:workout_player/view_models/progress_tab_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ChooseBackgroundScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final User user;
  final ChooseBackgroundScreenModel model;

  const ChooseBackgroundScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.user,
    required this.model,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {required User user}) async {
    final container = ProviderContainer();
    final auth = container.read(authServiceProvider);
    final database = container.read(databaseProvider(auth.currentUser?.uid));

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => ChooseBackgroundScreen(
            auth: auth,
            database: database,
            user: user,
            model: watch(chooseBackgroundScreenModelModel),
          ),
        ),
      ),
    );
  }

  @override
  _ChooseBackgroundScreenState createState() => _ChooseBackgroundScreenState();
}

class _ChooseBackgroundScreenState extends State<ChooseBackgroundScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.initSelectedImageIndex();
    widget.model.showFiles();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(blurSigma: 10),
        leading: const AppBarCloseButton(),
        title: Text(S.current.chooseWallpaper, style: TextStyles.subtitle2),
      ),
      body: Builder(
        builder: (context) => GridView.count(
          childAspectRatio: (2 / 3),
          crossAxisCount: 2,
          padding: EdgeInsets.only(
            top: Scaffold.of(context).appBarMaxHeight! + 16,
            bottom: kBottomNavigationBarHeight + 48,
            left: 16,
            right: 16,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
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
                  color: Colors.transparent,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    side: index == widget.model.selectedImageIndex
                        ? BorderSide(color: Colors.white, width: 2)
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
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: (widget.model.selectedImageIndex != null)
              ? () => widget.model.updateBackground(context)
              : null,
          backgroundColor: (widget.model.selectedImageIndex != null)
              ? kPrimaryColor
              : Colors.grey[700],
          label: Text(S.current.setWallpaper, style: TextStyles.button1_bold),
        ),
      ),
    );
  }
}
