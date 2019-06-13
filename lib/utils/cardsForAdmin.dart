import 'package:flutter/material.dart';
import '../models/productmodel.dart';
import '../productdetiles.dart';

class CardsForProductsinAdmin extends StatelessWidget {
  final ProductModel productmodel;

  CardsForProductsinAdmin({Key key, this.productmodel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetiles(
                    product: productmodel,
                  ))),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Image.network(
                        'https://shifon.ir/tmp/product_image/${productmodel.product_image}',
                        fit: BoxFit.cover,
                        height: 120,
                        width: 190,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            productmodel.product_name,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            productmodel.product_des,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade900),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 45, bottom: 5),
                            child: Text(
                              ' ${productmodel.product_price_buy} تومان',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red.shade600,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "قیمت :",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600),
                              ),
                              VerticalDivider(
                                width: 7,
                              ),
                              Text(
                                "${productmodel.product_price_sell} تومان",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
