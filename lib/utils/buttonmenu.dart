import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped/mainscoped.dart';
import './basketiconcount.dart';

class BTNMenu extends StatefulWidget {
  final Widget child;

  BTNMenu({Key key, this.child}) : super(key: key);

  _BTNMenuState createState() => _BTNMenuState();
}

class _BTNMenuState extends State<BTNMenu> {
  int _selectedIndex = 1;
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
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.grid_on,
                color: Colors.grey.shade400,
              ),
              title: Text('_'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_alarms, color: Colors.grey.shade400),
                title: Text('_')),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.grey.shade400),
                title: Text('_')),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border, color: Colors.grey.shade400),
                title: Text('_')),
            BottomNavigationBarItem(
                //  icon: Icon(Icons.person_outline, color: Colors.grey.shade400),
                icon: BasketCounter(itemcount: model.productcart.length),
                title: Text(
                  'سبدخرید',
                  style: TextStyle(color: Colors.grey),
                )),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.indigo,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        );
      },
    );
  }
}
