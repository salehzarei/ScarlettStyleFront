import 'package:flutter/material.dart';
import '../scoped/mainscoped.dart';
import '../models/productmodel.dart';

Future<void> checkProducts(
    BuildContext context, ProductModel product, MainModel model) async {
  List<String> errorMassages = [];
  if (product.product_category == null)
    errorMassages.add('دسته بندی انتخاب نشده');
  if (product.product_barcode.isEmpty) errorMassages.add('بارکد وارد نشده است');
  if (product.product_name.isEmpty) errorMassages.add('نام محصول وارد نشده');
  if (product.product_price_sell == '0' || product.product_price_sell.isEmpty)
    errorMassages.add('قیمت فروش وارد نشده');
  else if (int.parse(product.product_price_sell) <=
      int.parse(product.product_price_buy))
    errorMassages.add('قیمت فروش کمتر از خرید است');
  if (product.product_count.isEmpty)
    errorMassages.add('موجودی محصول وارد نشده');
  if (product.product_size.isEmpty)
    errorMassages.add('سایزبندی محصول وارد نشده');
  if (model.productImageFile == null)
    errorMassages.add('عکس محصول انتخاب نشده');

  if (errorMassages.length != 0)
    model.errorDialog(
        context: context,
        title: 'عزیزم ! دقت کن',
        desc: 'موارد زیر رو درست کن لطفا',
        content: Container(
          height: errorMassages.length.round() * 25.0,
          child: ListView.builder(
            itemCount: errorMassages.length,
            padding: EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Wrap(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.redAccent,
                    ),
                    Text(
                      errorMassages[index],
                      style: TextStyle(fontSize: 15, color: Colors.redAccent),
                      textAlign: TextAlign.right,
                    )
                  ],
                ),
              );
            },
          ),
        ));
  else {
    showAlert(context);
    model.addNewProduct(product).whenComplete(() {
       
      if (model.productAddedToServer)
model.successDialog(title: 'محصول با موفقیت ثبت شد', context: context);
      
        
    });
  }
}

  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            content: Container(
              width: 50,
              height: 80,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      ' ... ذخیره در سرور',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Spacer(),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ]),
            )));
  }