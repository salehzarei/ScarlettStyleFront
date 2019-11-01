import 'package:flutter/material.dart';
import '../models/productmodel.dart';

class ProductBasketCard extends StatelessWidget {
  final ProductModel product;
  final int index;
  final String count;

  ProductBasketCard({Key key, this.product, this.index, this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white54),
          child: ListTile(
            title: Text("لباس شماره ${product.product_name}"),
            contentPadding: EdgeInsets.only(top: 8, bottom: 8),
            leading: DecoratedBox(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Image.network(
                'https://shifon.ir/tmp/product_image/${product.product_image}',
                height: 70,
                width: 50,
                fit: BoxFit.cover,
              ),
              position: DecorationPosition.background,
            ),
            subtitle: Column(
              children: <Widget>[
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("رنگ : "),
                          CircleAvatar(
                            backgroundColor: Colors.pink,
                            maxRadius: 5,
                          )
                        ]),
                    VerticalDivider(
                      color: Colors.black,
                    ),
                    Text("سایز : XL")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      color: Colors.pink.shade100,
                      size: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("قیمت  : ${product.product_price_sell}  تومان"),
                  ],
                ),
              ],
            ),
            trailing: Padding(
                padding: const EdgeInsets.only(left: 20 ,top: 20),
                child: Text(
                  count,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
                )),
            //dense: true,
          ),
        ),
      ),
    );
  }
}
