import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped/mainscoped.dart';
import './basketiconcount.dart';

class BTNMenu extends StatefulWidget {
  //final VoidCallback pageindex;

 // BTNMenu({Key key, this.pageindex}) : super(key: key);

  _BTNMenuState createState() => _BTNMenuState();
}

class _BTNMenuState extends State<BTNMenu> {
  int _selectedIndex = 1;
  Color _selectedcolor = Colors.pink;
  Color _color = Colors.grey.shade400;
  // final _widgetOption = [
  //   Text('index 0: Home'),
  //   Text('index 1: Home'),
  //   Text('index 2: Home'),
  //   Text('index 3: Home'),
  //   Text('index 4: Home')
  // ];
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return BottomNavigationBar(
          backgroundColor: Colors.white54.withOpacity(0.8),
          elevation: 0.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_on,
                  color: _selectedIndex == 0 ? _selectedcolor : _color),
              title: Text(
                'نمیدونم',
                style: TextStyle(
                    fontSize: 10,
                    color: _selectedIndex == 0 ? _selectedcolor : _color),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box,
                    color: _selectedIndex == 1 ? _selectedcolor : _color),
                title: Text(
                  'افزودن محصول جدید',
                  style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 1 ? _selectedcolor : _color),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    color: _selectedIndex == 2 ? _selectedcolor : _color),
                title: Text(
                  'نمیدونم',
                  style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 2 ? _selectedcolor : _color),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border,
                    color: _selectedIndex == 3 ? _selectedcolor : _color),
                title: Text(
                  'نمیدونم',
                  style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 3 ? _selectedcolor : _color),
                )),
            BottomNavigationBarItem(
                //  icon: Icon(Icons.person_outline, color: Colors.grey.shade400),
                icon: BasketCounter(
                  itemcount: model.productcart.length,
                  colors: _selectedIndex == 4 ? _selectedcolor : _color,
                ),
                title: Text(
                  'سبدخرید',
                  style: TextStyle(
                      fontSize: 10,
                      color: _selectedIndex == 4 ? _selectedcolor : _color),
                )),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.grey,
          onTap: (int index) {
          //  widget.pageindex();
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      },
    );
  }
}
