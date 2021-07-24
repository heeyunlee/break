import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/private_keys.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    _instance = await Mixpanel.init(
      PrivateKeys.mixpanelToken,
      optOutTrackingDefault: false,
    );

    logger.d('mixpanel initiated $_instance');
    return _instance!;
  }

  static void track(String eventName) {
    return _instance!.track(eventName);
  }
}
