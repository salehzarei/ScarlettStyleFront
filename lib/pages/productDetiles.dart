import "package:flutter/material.dart";
import 'package:scarlettstayle/models/productmodel.dart';
import 'package:scarlettstayle/utils/menu.dart';

class ProductDetiles extends StatelessWidget {
  final ProductModel product;
  const ProductDetiles({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fromTop = MediaQuery.of(context).size.height * 0.61;
    double fromLeft = MediaQuery.of(context).size.width * 0.03;
    double fromRight = MediaQuery.of(context).size.width * 0.1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawer: Menu(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://shifon.ir/tmp/product_image/${product.product_image}'),
                        fit: BoxFit.cover)),
              ),
              Positioned(
                bottom: 40,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 78,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "قیمت خرید :",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "${product.product_price_sell} تومان",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "توضیحات :",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "${product.product_des}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                                                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "تعداد :",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "${product.product_count} عدد",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "سایز :",
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "${product.product_size}",
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
              Positioned(
                left: 0,
                top: 50,
                child: Container(
                  width: 180,
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text("کد : ${product.product_barcode}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17)),
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1.0,
                            color: Colors.black54,
                            offset: Offset.fromDirection(1.0))
                      ],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15))),
                ),
              ),
              Positioned(
                top: fromTop,
                right: fromRight,
                child: Container(
                  width: 290,
                  height: 110,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          product.product_name,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text("دسته بندی: ${product.product_category}"),
                      ),
                      Container(
                          width: 200,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.purple.shade800,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "قیمت فروش :",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                              Text(
                                "${product.product_price_sell} تومان",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: fromTop + 25,
                  left: fromLeft,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey,
                    ),
                    backgroundColor: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
