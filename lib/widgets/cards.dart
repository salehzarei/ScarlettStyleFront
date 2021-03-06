import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scarlettstayle/pages/productDetiles.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/productmodel.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productmodel;

  ProductCard({Key key, this.productmodel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetiles(
                        product: productmodel,
                      ))),
          child: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Positioned(
                      top: 10,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                        imageUrl:
                            'https://shifon.ir/tmp/product_image/${productmodel.product_image}',
                        imageBuilder: (context, imageProvider) => Container(
                          height: 215,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5.0,
                                    color: Colors.grey.shade300,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 5))
                              ],
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                         
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 55,
                            width: 151,
                            alignment: Alignment.topCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Text(
                                      productmodel.product_count +
                                          " ?????? - ???????? " +
                                          productmodel.product_size,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.pink)),
                                ),
                                Text(productmodel.product_name,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        color: Colors.grey.shade800)),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                          ),
                        ),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    width: 110,
                    height: 22,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    child: Text(
                      '???? ${productmodel.product_barcode}',
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Positioned(
                    top: 215,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.shade100.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        width: 125,
                        height: 25,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(2),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: <Widget>[
                            Text(
                                model.fixPrice(productmodel.product_price_sell),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17)),
                            Text(
                              ' ?????????? ',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                  ),
                ],
              )),
        );
      },
    );
  }
}
