import 'package:arabi_dic/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white10, // set Status bar color in Android devices
      statusBarIconBrightness: Brightness.dark, // set Status bar icons color in Android devices
      statusBarBrightness: Brightness.dark, // set Status bar icon color in iOS
    )
    );
    return GetMaterialApp(
      title: 'دیکشنری عربی',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Mj_Tunisia_Bd',useMaterial3: true,cardTheme: CardTheme(
        surfaceTintColor: Colors.white,
      ),),
      home: const Directionality(textDirection: TextDirection.rtl, child: Home()),
    );
  }
}






