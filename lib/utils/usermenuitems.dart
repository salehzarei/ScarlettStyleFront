import 'package:flutter/material.dart';
import '../theme/menutheme.dart';
import '../scoped/mainscoped.dart';
import '../collection.dart';

class UserMenuItems extends StatefulWidget {
  final MainModel model;
  final int menuitemindex;
  final IconData icon;

  UserMenuItems(
      {Key key,
      @required this.menuitemindex,
      @required this.icon,
      @required this.model})
      : super(key: key);

  _UserMenuItemsState createState() => _UserMenuItemsState();
}

class _UserMenuItemsState extends State<UserMenuItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Collection(
                    model: widget.model,
                    catid: widget
                        .model.categoriData[widget.menuitemindex].categorie_id,
                    title: widget.model.categoriList.values
                        .elementAt(widget.menuitemindex)))),
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
              widget.model.categoriList.values.elementAt(widget.menuitemindex),
              style: menuDefultTitleStyle,
            )
          ],
        ),
      ),
    );
  }
}
