import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped/mainscoped.dart';
import 'dart:io';
import 'dart:async';

import 'pages/productManage.dart';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

String loadingText = '' ;
int time = 10 ;

  @override
  void initState() {
    super.initState();
    MainModel model = ScopedModel.of(context);
    model.fetchProducts().whenComplete((){
      setState(() {
           time = 0 ;
          });
    });
   chekinternet();
  }


 Future<void> chekinternet() async {
      try {
        final result = await InternetAddress.lookup('shifon.ir');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
          setState(() {
           loadingText ='کمی صبر کنید' ;
           time = 2 ;
          });
        }
      } on SocketException catch (_) {
        print('not connected');
        setState(() {
         loadingText =  'اینترنت گوشی وصل نیست'; 
         time = 50;
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: time,
      loadingText: Text(loadingText,style: TextStyle(color: Colors.white),),
      navigateAfterSeconds: ProductManage(),
      title: Text(
        'اپلیکیشن اسکارلت',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset('images/scarlett.png'),
      gradientBackground: LinearGradient(
          colors: [Colors.pinkAccent.shade50, Colors.pinkAccent.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 180.0,
      onClick: () => print("عجله نکن بابا"),
      loaderColor: Colors.white,
    );
  }
}
