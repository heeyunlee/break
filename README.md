<h1 align="center">
  <a name="logo"><img src="https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/Icons%2Fherakles_icon.svg?alt=media&token=7a7edfab-cb91-4eaf-a98a-6c1c9002ea84" alt="Herakles" width="120"></a>
  <br>
  <br>
  Herakles: Workout Player
  <br>
  <br>

  [![Get it from App Store](https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/README.md%2FDownload_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg?alt=media&token=8681ed8f-b1c5-417a-bb4b-338009480c2d)](https://apps.apple.com/us/app/herakles-workout-player/id1555829140) [![Get it on Google Play](https://lisk.io/sites/default/files/pictures/2020-01/download_on_the_play_store_badge.svg)](https://play.google.com/store/apps/details?id=com.healtine.playerh)
</h1>

#### Herakles is health & fitness tracking app built with Flutter and Firebase. User can make a customizable dashboard to see their progress or use YouTbe-like miniplayer to workout in real time.
<br>
<br>

### **Table of contents**
- [**Introduction**](#introduction)
- [**Preview & Sign In Screen**](#preview--sign-in-screen)
- [**To Do**](#to-do)

<br>
<br>

## Introduction
Herakles is a health & fitness tracking app with customizable dashboard (with iOS-like widgets) and workout player (YouTube-like miniplayer and displays your current workout)

<br>
<br>

## Preview & Sign In Screen
The preview screen showcases different widgets that users can use on the progress tab using `AnimatedSwitcher()` widget. On SingInScreen, I used Firebase Auth to authenticate users through email or different social sign-in providers, including `Kakao`.  

For transition between PreviewScreen and SignInScreen, I made a custom `PageRouteBuilder()` and `AnimatedBuilder()` to create staggered animation effects for sign-in buttons and fading effects for all the other widgets.

### Preview Screen & Transition Between Preview Screen and Sign In Screen
<p align="left">
    <img src="previews/preview_screen_ios.gif" alt="Assessment 1, Android" width="200"/>
    &nbsp;
    &nbsp;
    &nbsp;
    <img src="previews/sign_in_screen_ios.gif" alt="Assessment 1, iOS" width="200"/>
</p>

## To Do
### Refactoring
#### This project is always-changing and always-improving. As I learn more about Flutter, and especially more about better factoring, I need to refactor old codes to make them better. Below are my refactoring to-do lists
- [x] Add Workout To Routine Screen
- [x] Create Routine Screen
- [ ] Edit Routine Screen
- [ ] Log Routine Screen
- [ ] Routine History Tab
- [x] Routine Workout Card
- [ ] Workout Set Widget (half way done)
- [ ] Saved Routines Screen
- [x] Routine Detail Screen
- [ ] Create Workout Screen
- [ ] Edit Workout Screen
- [ ] Saved Workout Screen
- [ ] Workout Histories Tab
- [ ] Add Workout To Routine Screen
- [ ] Workout Detail Screen
- [ ] Measurements Screen
- [ ] Measurements Line Chart Widget
- [ ] Nutritions Screen
- [ ] Weekly Nutrition Chart
- [ ] Weights Lifted Chart Widget
- [ ] Search Tab
- [ ] Search Tab Body Widget
- [ ] Change Display Name Screen
- [ ] Change Email Screen
- [ ] Delete Account Screen
- [ ] Change Language Screen
- [ ] Unit Of Mass Screen
- [ ] User Feedback Screen
- [x] Home Screen
- [x] Add Measurement Screen
- [x] Add Nutrition Screen
- [ ] Start Workout Shortcut Screen
- [ ] SpeedDial
- [x] Preview Screen
