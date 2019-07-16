import 'package:flutter/material.dart';

class BasketCounter extends StatelessWidget {
  final int itemcount;
  final Color colors;

  BasketCounter({Key key, this.itemcount, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Icon(
          Icons.shopping_basket,
          color: colors == null ? Colors.grey.shade700 : colors,
        ),
        Positioned(
            bottom: 15,
            left: 13,
            child: itemcount != 0
                ? Container(
                    alignment: Alignment.center,
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red),
                    child: Text(
                      itemcount.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container())
      ],
    );
  }
}
