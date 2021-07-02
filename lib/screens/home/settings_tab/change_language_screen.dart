import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../styles/constants.dart';

class ChangeLanguageScreen extends StatefulWidget {
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ChangeLanguageScreen(),
      ),
    );
  }

  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _currentLang = Intl.getCurrentLocale();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text('Language Preference', style: kSubtitle1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          tileColor:
              (_currentLang == 'ko') ? kPrimaryColor : Colors.transparent,
          title: const Text('한국어', style: kBodyText1),
          trailing: (_currentLang == 'ko')
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () async {
            await S.load(Locale('ko'));
            setState(() {
              _currentLang = Intl.getCurrentLocale();
            });
            // print(_currentLang);
          },
        ),
        ListTile(
          tileColor:
              (_currentLang == 'en') ? kPrimaryColor : Colors.transparent,
          title: const Text('English', style: kBodyText1),
          trailing: (_currentLang == 'en')
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () async {
            await S.load(Locale('en'));
            setState(() {
              _currentLang = Intl.getCurrentLocale();
            });
            // print(_currentLang);
          },
        ),
      ],
    );
  }
}
