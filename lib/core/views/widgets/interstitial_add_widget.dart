import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;

  static const String _adUnitId =
      'ca-app-pub-4023356754088047/3162125587'; // test ID

  /// Call this to preload the ad before you need to show it
  void loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: ${error.message}');
        },
      ),
    );
  }

  /// Call this at the right moment to show the ad
  void showAd() {
    if (_interstitialAd == null) {
      debugPrint('Ad not ready yet.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadAd(); // Preload the next one immediately
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}

