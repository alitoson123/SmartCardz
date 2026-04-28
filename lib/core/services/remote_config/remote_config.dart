import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';

class RemoteConfigService {
  static final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration(
          hours: 1,
        ), // Production ممكن تخليها 1 ساعة
      ),
    );

    await remoteConfig.setDefaults({
      "baseUrl": "https://smartcardz-ai-3.onrender.com/",
    });
    if (await NetworkUtils.isOnline()) {
      try {
        await remoteConfig.fetchAndActivate();
      } catch (e) {
        print("Remote config fetch failed (likely throttled): $e");
        // Fallback to defaults gracefully
      }
    } else {
      print("Offline: using default remote config values.");
    }
  }

  static String getBaseUrl() {
    return remoteConfig.getString("baseUrl");
  }

  // https://smartcardz-ai-3.onrender.com/
  // https://gallant-radiance-production-d7c3.up.railway.app/
}
