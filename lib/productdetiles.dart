import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'dart:math';
import './models/productmodel.dart';
import './scoped/mainscoped.dart';
import './utils/basketiconcount.dart';
import './utils/colormenu.dart';
import './utils/sizemenu.dart';

class ProductDetiles extends StatefulWidget {
  final ProductModel product;

  ProductDetiles({Key key, this.product}) : super(key: key);

  _ProductDetilesState createState() => _ProductDetilesState();
}

class _ProductDetilesState extends State<ProductDetiles> {
  bool isfave = true;
  int itemcount;
  var _price = MoneyMaskedTextController(
      precision: 0, thousandSeparator: '/', decimalSeparator: '');

  @override
  void initState() {
    _price.updateValue(double.parse(widget.product.product_price_sell));
    super.initState();
  }

  addproducttocardMap(MainModel model) {
    int _prokey = Random().nextInt(100);
    model.productcart.addAll({_prokey: widget.product});
    setState(() {
      itemcount = model.productcart.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showsnakbar(String name) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('$name به سبد اضافه شد'),
        duration: Duration(microseconds: 1),
      ));
    }

    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Stack(fit: StackFit.expand, children: <Widget>[
        Image.network(
          'https://shifon.ir/tmp/product_image/${widget.product.product_image}',
          fit: BoxFit.cover,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: isfave
                        ? Icon(
                            Icons.favorite_border,
                            color: Colors.grey.shade700,
                          )
                        : Icon(
                            Icons.favorite,
                            color: Colors.red.shade700,
                          ),
                    onPressed: () {
                      setState(() {
                        isfave = !isfave;
                      });
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/basket'),
                        child: BasketCounter(
                            itemcount: model.productcart.length))),
              ],
            ),
            body: Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(top: 430),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Row(
                        textDirection: TextDirection.rtl,
                        children: <Widget>[
                          Container(
                            color: Colors.pink.shade200,
                            height: 50,
                            width: 7,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.product.product_des,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade700),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.product.product_name,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.bold),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.pink.shade200,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 40,
                                width: 50,
                                child: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                addproducttocardMap(model);
                                SnackBar snackbar = SnackBar(
                                  backgroundColor: Colors.greenAccent.shade200,
                                     content: Text(
                                    " یک عدد ${widget.product.product_name} به سبد اضافه شد",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                );
                                Scaffold.of(context).showSnackBar(snackbar);
                              },
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.pink.shade50,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 40,
                              width: 286,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    "${_price.text} تومان",
                                    textDirection: TextDirection.rtl,
                                  ),
                                  DressColors(),
                                  DressSizeMenu()
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ]);
    });
  }
}
