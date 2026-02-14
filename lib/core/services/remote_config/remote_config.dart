import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';

class RemoteConfigService {
  static final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero, // Production ممكن تخليها 1 ساعة
      ),
    );

    await remoteConfig.setDefaults({
      "baseUrl": "https://smartcardz-ai-3.onrender.com/",
    });
    if (await NetworkUtils.isOnline()) {
      await remoteConfig.fetchAndActivate();
    }
  }

  static String getBaseUrl() {
    return remoteConfig.getString("baseUrl");
  }
}
