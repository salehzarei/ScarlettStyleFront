import 'package:flutter/material.dart';

class DressSizeMenu extends StatefulWidget {
  final Widget child;

  DressSizeMenu({Key key, this.child}) : super(key: key);

  _DressSizeMenuState createState() => _DressSizeMenuState();
}

class _DressSizeMenuState extends State<DressSizeMenu> {
  String _selectedSize;

  final List<String> _dressSize = ['S', 'M', 'L', 'XL'];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(

      items: _dressSize.map((String val) {
        return DropdownMenuItem<String>(value: val, child: Text(val));
      }).toList(),
      hint: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: 
              Icon(Icons.straighten,color: Colors.grey.shade600, size: 20,)),
          Text(_selectedSize ?? _dressSize[0])
        ],
      ),
      onChanged: (String val) {
        setState(() {
          _selectedSize = val;
        });
      },
    ));
  }
}
