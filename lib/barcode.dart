import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScan extends StatefulWidget {
  const BarcodeScan({Key key}) : super(key: key);

  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  String _barcode = 'بارکد نیست !';
  String _code = '';

  Future scanBarcode() async {
    _code = await FlutterBarcodeScanner.scanBarcode('#009922', 'انصراف', true);

    setState(() {
      _barcode = _code;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اسکن بارکد'),
      ),
      body: Center(child: Text(_barcode)),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.scanner),
        onPressed: () => scanBarcode(),
      ),
    );
  }
}
