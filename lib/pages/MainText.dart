import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../ads/AppLifecycleReactor.dart';
import '../ads/AppOpenAdManager.dart';
import '../ads/banner/banner_view.dart';

class MainText extends StatelessWidget {
  final String vag;
  final String tarjoma;
  const MainText({super.key, required this.vag, required this.tarjoma});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _MainText(vag: vag, tarjoma: tarjoma,),
    );
  }
}

class _MainText extends StatefulWidget {
  final String vag;
  final String tarjoma;
  const _MainText({super.key, required this.vag, required this.tarjoma});

  @override
  State<_MainText> createState() => _MainTextState();
}

class _MainTextState extends State<_MainText> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.vag),
          backgroundColor: Colors.blueGrey[50],
          actions: [
            IconButton(onPressed: () async {

              late AppLifecycleReactor _appLifecycleReactor;
              AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
              _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
              _appLifecycleReactor.listenToAppStateChanges();

              await Clipboard.setData(ClipboardData(text:"${widget.vag}\n${widget.tarjoma}"));
              const snackBar = SnackBar(
                content: Text('محتویات کپی شد.', textDirection: TextDirection.rtl,),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }, icon: Icon(
              Icons.copy
            )),

            IconButton(onPressed: (){

              late AppLifecycleReactor _appLifecycleReactor;
              AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
              _appLifecycleReactor = AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
              _appLifecycleReactor.listenToAppStateChanges();


              Share.share("${widget.vag}\n${widget.tarjoma}",subject: 'دیگشنری عربی');
              }, icon: Icon(
                Icons.share
            )),

          ],
        ),

        body:  Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(widget.vag, textAlign: TextAlign.right, style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 10)
              ,child: Container(color: Colors.black, height: 0.5,)),
              Align(
                alignment: Alignment.centerRight,
                child: Text(widget.tarjoma, textAlign: TextAlign.right, style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BannerComponent(),
      ),
    );
  }
}

