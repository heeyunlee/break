import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    _instance = await Mixpanel.init(
      'de3edf0f7f37fd6ccf2e07dbb7291b5d',
      optOutTrackingDefault: false,
    );
    return _instance!;
  }
}
