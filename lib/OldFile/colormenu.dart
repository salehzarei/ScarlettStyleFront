import 'package:flutter/material.dart';

class DressColors extends StatefulWidget {
  final Widget child;

  DressColors({Key key, this.child}) : super(key: key);

  _DressColorsState createState() => _DressColorsState();
}

class _DressColorsState extends State<DressColors> {
  String _selectedcolorname;
  Color _selectedcolor;

  final Map<String, Color> _dresscolor = Map.fromIterables(
      ['صورتی', 'قرمز', 'آبی', 'سیاه', 'خاکستری'],
      [Colors.pink, Colors.red, Colors.blue, Colors.black, Colors.grey]);

  @override
  Widget build(BuildContext context) {
       return DropdownButtonHideUnderline(
        child: DropdownButton(
      items: _dresscolor.keys.map((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: CircleAvatar(
                  backgroundColor: _dresscolor[val],
                  maxRadius: 8,
                ),
              ),
              Text(val)
            ],
          ),
        );
      }).toList(),
      hint: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: CircleAvatar(
             backgroundColor: _selectedcolor ??_dresscolor.values.toList()[0],
             maxRadius: 8,
            ),
          ),
          Text(_selectedcolorname ?? _dresscolor.keys.toList()[0])
        ],
      ),
      onChanged: (String val) {
        setState(() {
          _selectedcolorname = val;
          _selectedcolor = _dresscolor[val];
        });
      },
    ));
  }
}
