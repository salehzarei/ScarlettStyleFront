import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scarlettstayle/pages/addNewProduct.dart';
import 'package:scarlettstayle/products/addnewProducts.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped/mainscoped.dart';
import './splashScreen.dart';
import './collection.dart';
import './productdetiles.dart';
import './basket.dart';
import './manageCategorie.dart';
import './manageProducts.dart';
import 'barcode.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
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
             // '/': (context) => Splash(),
             '/':(context)=>AddNewProduct(),
              '/collection': (context) => Collection(),
              '/productdetiles': (context) => ProductDetiles(),
              '/basket': (context) => Basket(model: model),
              '/managecategories': (context) => ManageCategories(model: model),
              '/manageproducts': (context) => ManageProduct(),
              '/scan':(context)=>BarcodeScan(),
              '/addnewProduct' :(context)=>ADDProduct()
            },
          )),
    );
  });
}
