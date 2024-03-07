import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constant.dart';

class BannerLogic extends GetxController {
  BannerAd? anchoredAdaptiveAd;
  bool isLoaded = false;
  late Orientation currentOrientation;

  @override
  void onInit() {
    super.onInit();
    reset();
  }

  void reset() {
    anchoredAdaptiveAd?.dispose();
    anchoredAdaptiveAd = null;
    isLoaded = false;
  }

  Future<void> loadAd(BuildContext context) async {
    print('Loading anchored banner ad.');
    currentOrientation = MediaQuery.of(context).orientation;

    // reset the ad
    reset();

    // get the height of the anchored banner
    final AnchoredAdaptiveBannerAdSize? size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    // create the anchored banner
    anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid ? Constant.bannerAdUnidId : Constant.bannerAdUnidId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          anchoredAdaptiveAd = ad as BannerAd;
          isLoaded = true;
          update(['banner']);
          print('$ad loaded: ${ad.responseInfo}');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
          isLoaded = false;
          update(['banner']);
        },
      ),
    );
    return anchoredAdaptiveAd!.load();
  }

  @override
  void onClose() {
    super.onClose();
    anchoredAdaptiveAd?.dispose();
  }
}
