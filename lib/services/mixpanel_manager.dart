import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/services/private_keys.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  Future<Mixpanel> init() async {
    _instance = await Mixpanel.init(
      mixpanelToken,
      // optOutTrackingDefault: false,
    );

    logger.d('mixpanel initiated $_instance');
    return _instance!;
  }

  void track(String eventName) {
    return _instance!.track(eventName);
  }
}
