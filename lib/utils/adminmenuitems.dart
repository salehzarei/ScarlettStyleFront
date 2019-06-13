import 'package:flutter/material.dart';
import '../theme/menutheme.dart';


class AdminMenuItems extends StatefulWidget {
 
  final String menutitle;
  final IconData icon;
  final String link;

  AdminMenuItems(
      {Key key,
      @required this.menutitle,
      @required this.icon,
      this.link,
      })
      : super(key: key);

  _AdminMenuItemsState createState() => _AdminMenuItemsState();
}

class _AdminMenuItemsState extends State<AdminMenuItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, widget.link),
        splashColor: Colors.pink,
        child: Row(
          children: <Widget>[
            Icon(
              widget.icon,
              color: iconColor,
              size: 20,
            ),
            SizedBox(width: 7),
            Text(
              widget.menutitle,
              style: menuDefultTitleStyle,
            )
          ],
        ),
      ),
    );
  }
}
