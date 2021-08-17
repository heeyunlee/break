import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workout_player/styles/text_styles.dart';

void getSnackbarWidget(String title, String message, {int? duration}) {
  return Get.snackbar(
    title,
    message,
    animationDuration: Duration(milliseconds: 500),
    backgroundColor: Colors.grey[700]!.withOpacity(0.75),
    snackPosition: SnackPosition.TOP,
    titleText: Text(title, style: TextStyles.body2_grey),
    messageText: Text(message, style: TextStyles.body2),
    borderRadius: 8,
    duration: Duration(seconds: duration ?? 2),
  );
}