import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'banner_logic.dart';

class BannerComponent extends StatelessWidget {
  const BannerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(BannerLogic());

    return SafeArea(
      child: GetBuilder(
          initState: (_) => logic.loadAd(context),
          init: logic,
          id: 'banner',
          builder: (_) {
            return OrientationBuilder(
              builder: (context, orientation) {
                if (logic.currentOrientation == orientation && logic.anchoredAdaptiveAd != null && logic.isLoaded) {
                  return Container(
                    color: Colors.transparent,
                    width: logic.anchoredAdaptiveAd!.size.width.toDouble(),
                    height: logic.anchoredAdaptiveAd!.size.height.toDouble(),
                    child: AdWidget(ad: logic.anchoredAdaptiveAd!),
                  );
                }
                // Reload the ad if the orientation changes.
                if (logic.currentOrientation != orientation) {
                  logic.currentOrientation = orientation;
                  logic.loadAd(context);
                }
                return const SizedBox(width: 0, height: 0);
              },
            );
          }),
    );
  }
}
