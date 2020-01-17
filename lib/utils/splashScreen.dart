import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scarlettstayle/pages/productManage.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String _loadingText = '';
  int _time = 10;
  bool _isInternet = true;

  @override
  void initState() {
    super.initState();
    MainModel model = ScopedModel.of(context);
    chekinternet().whenComplete(() {
      if (_isInternet) {
        model.fetchProducts().whenComplete(() {
          setState(() {
            _time = 0;
          });
        });
      } else {
        SystemNavigator.pop();
      }
    });
  }

  Future<void> chekinternet() async {
    try {
      final result = await InternetAddress.lookup('shifon.ir');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        setState(() {
          _loadingText = 'کمی صبر کنید';
        });
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        _loadingText = 'اینترنت گوشی وصل نیست';
        _isInternet = false;
        _time = 20;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: _time,
      loadingText: Text(
        _loadingText,
        style: TextStyle(color: Colors.white),
      ),
      navigateAfterSeconds: ProductManage(),
      title: Text(
        'اپلیکیشن مزون ارکیده',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
      ),
      image: Image.asset('images/scarlett.png'),
      gradientBackground: LinearGradient(
          colors: [Colors.pink.shade100, Colors.pinkAccent.shade700],
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
