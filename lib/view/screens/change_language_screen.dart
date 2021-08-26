import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';

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
        title: Text(S.current.languagePreference, style: TextStyles.subtitle1),
        leading: const AppBarBackButton(),
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
          title: const Text('한국어', style: TextStyles.body1),
          trailing: (_currentLang == 'ko')
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () async {
            await S.load(const Locale('ko'));
            setState(() {
              _currentLang = Intl.getCurrentLocale();
            });
          },
        ),
        ListTile(
          tileColor:
              (_currentLang == 'en') ? kPrimaryColor : Colors.transparent,
          title: const Text('English', style: TextStyles.body1),
          trailing: (_currentLang == 'en')
              ? const Icon(Icons.check, color: Colors.white)
              : null,
          onTap: () async {
            await S.load(const Locale('en'));
            setState(() {
              _currentLang = Intl.getCurrentLocale();
            });
          },
        ),
      ],
    );
  }
}
