import "package:flutter/material.dart";
import 'package:scarlettstayle/models/productmodel.dart';
import 'package:scarlettstayle/theme/textStyle.dart';
import 'package:scarlettstayle/utils/menu.dart';

class ProductDetiles extends StatelessWidget {
  final ProductModel product;
  const ProductDetiles({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.purple),
          centerTitle: true,
          title: Text(
            'جزئیات محصول',
            style: titleStyle,
          ),
        ),
        drawer: Menu(),
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://shifon.ir/tmp/product_image/${product.product_image}'),
                  fit: BoxFit.cover
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
