import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import './scoped/mainscoped.dart';
import './models/productmodel.dart';
import './utils/buttonmenu.dart';
import './utils/productbasketcard.dart';

class Basket extends StatefulWidget {
  final MainModel model;
  final ProductModel product;

  Basket({Key key, this.model, this.product}) : super(key: key);

  _BasketState createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  double totalprice = 0.0;

  var _pricecontroller = MoneyMaskedTextController(
      precision: 0, thousandSeparator: '/', decimalSeparator: '');

  @override
  void initState() {
    totalprice = calctotal();
    _pricecontroller.updateValue(totalprice);
    super.initState();
  }

  calctotal() {
    int count = widget.model.productcart.length;

    var keys = widget.model.productcart.keys.toList();

    for (int i = 0; i < count; i++) {
      totalprice = totalprice +
          int.parse(widget.model.productcart[keys[i]].product_price_sell);
    }
    return totalprice;
  }

  changetotal(int deletedprice) {
    totalprice = totalprice - deletedprice;
    _pricecontroller.updateValue(totalprice);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700),
              onPressed: () => totalprice == 0 ? Navigator.pushNamed(context, '/') : Navigator.pop(context),
            ),
            title: Text('سبد خرید شما',
                style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
            centerTitle: true,
          ),
          backgroundColor: Colors.pink.shade50,
          bottomNavigationBar: BTNMenu(),
          body: totalprice == 0
              ? Center(
                  child: Text("عزیزم ! سبد خرید شما خالی است"),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: model.productcart.length,
                        itemBuilder: (context, index) {
                          var keys = model.productcart.keys.toList();
                          final item = keys[index].toString();

                          return Dismissible(
                            key: Key(item),
                            onDismissed: (direction) {
                              int deletedprice = int.parse(model
                                  .productcart[keys[index]].product_price_sell);
                              setState(() {
                                model.productcart.remove(keys[index]);

                                changetotal(deletedprice);
                              });
                            },
                            child: ProductBasketCard(
                                product: model.productcart[keys[index]],
                                index: index,
                                count: 1.toString()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.pink.shade100,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "جمع فاکتور : ${_pricecontroller.text} تومان",
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green.shade400,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 40,
                              width: 80,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  Text(
                                    "پرداخت فاکتور",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
