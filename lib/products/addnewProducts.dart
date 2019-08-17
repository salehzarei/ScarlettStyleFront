import 'package:flutter/material.dart';

class ADDProduct extends StatefulWidget {
  ADDProduct({Key key}) : super(key: key);

  _ADDProductState createState() => _ADDProductState();
}

class _ADDProductState extends State<ADDProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافه کردن محصول جدید'),
        
      ),
    );
  }
}
