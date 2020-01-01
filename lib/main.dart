import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scarlettstayle/pages/addNewProduct.dart';
import 'package:scarlettstayle/pages/productManage.dart';
import 'package:scarlettstayle/pages/saleProducts.dart';
import 'package:scarlettstayle/utils/splashScreen.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped/mainscoped.dart';
import 'pages/categoryManage.dart';

void main() {
  MainModel model = MainModel();
  runApp(
    ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.grey.shade300,
            scaffoldBackgroundColor: Colors.pink.shade50,
            textTheme: TextTheme(
                title: TextStyle(
                    fontSize: 25,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold)),
            fontFamily: 'BYekan',
          ),
          initialRoute: '/',
          routes: <String, WidgetBuilder>{
            '/': (context) => Splash(),
            '/saleproducts': (context) => SaleProducts(),
            '/managecategories': (context) => CategoryManage(),
            '/manageproducts': (context) => ProductManage(),
            '/addnewProduct': (context) => AddNewProduct(),
          },
        )),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
