import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

final chooseBackgroundScreenModelModel = ChangeNotifierProvider(
  (ref) => ChooseBackgroundScreenModel(),
);

class ChooseBackgroundScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  ChooseBackgroundScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  int? _selectedImageIndex;
  // XFile? _pickedImageFile;
  File? _image;
  // ignore: prefer_final_fields
  List<String> _personalImagesUrls = [];

  int? get selectedImageIndex => _selectedImageIndex;
  // XFile? get pickedImageFile => _pickedImageFile;
  File? get image => _image;
  List<String> get personalImagesUrls => _personalImagesUrls;

  void setselectedImageIndex(int? index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  // Future<void> showModalBottomSheet(BuildContext context) async {
  //   await showAdaptiveModalBottomSheet(
  //     context,
  //     firstActionText: 'Camera',
  //     isFirstActionDefault: true,
  //     firstActionOnPressed: () => _openCamera(context),
  //     secondActionText: 'Album',
  //     isSecondActionDefault: true,
  //     secondActionOnPressed: () => _openGallery(context),
  //   );
  // }

  // void _openGallery(BuildContext context) async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   _pickedImageFile = pickedFile;
  //   if (_pickedImageFile != null) {
  //     _image = File(pickedImageFile!.path);
  //   }

  //   Navigator.of(context).pop();

  //   notifyListeners();
  // }

  // void _openCamera(BuildContext context) async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //   );
  //   _pickedImageFile = pickedFile;
  //   if (_pickedImageFile != null) {
  //     _image = File(pickedImageFile!.path);

  //     final id = Uuid().v4();

  //     await _uploadFile(_image!, id);
  //   }
  //   Navigator.of(context).pop();

  //   notifyListeners();
  // }

  // Future<void> _uploadFile(File file, String id) async {
  //   try {
  //     await FirebaseStorage.instance
  //         .ref('users/${auth!.currentUser!.uid}/bg/$id.jpg')
  //         .putFile(file);
  //   } on FirebaseException catch (e) {
  //     logger.e(e);
  //     throw UnimplementedError();
  //   }
  // }

  // Future<void> showFiles() async {
  //   ListResult result = await FirebaseStorage.instance
  //       .ref('users/${auth!.currentUser!.uid}/bg')
  //       .list();

  //   final items = result.items;

  //   items.forEach((element) async {
  //     final url = await element.getDownloadURL();

  //     _personalImagesUrls.add(url);
  //   });
  // }

  Future<void> initSelectedImageIndex() async {
    final user = await database!.getUserDocument(auth!.currentUser!.uid);

    _selectedImageIndex = user!.backgroundImageIndex;
    notifyListeners();
  }

  Future<void> updateBackground(BuildContext context) async {
    final user = {
      'backgroundImageIndex': _selectedImageIndex,
    };

    await database!.updateUser(auth!.currentUser!.uid, user);

    Navigator.of(context).pop();

    getSnackbarWidget(
      S.current.updateBackgroundSnackbarTitle,
      S.current.updateBackgroundSnackbarMessage,
    );
  }
}
