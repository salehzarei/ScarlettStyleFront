import 'package:flutter/material.dart';



class BarcodeScan extends StatefulWidget {
  const BarcodeScan({Key key}) : super(key: key);

  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String _barcode = 'بارکد نیست !';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اسکن بارکد'),
      ),
      body: Center(child: Text(_barcode)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.scanner),
        onPressed: ()=>null,
      ),
    );
  }
}
