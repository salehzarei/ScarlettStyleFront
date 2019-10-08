import 'package:flutter/material.dart';
import '../scoped/mainscoped.dart';
import '../models/productmodel.dart';

Future<void> checkProducts(
    BuildContext context, ProductModel product, MainModel model) async {
  List<String> errorMassages = [];
  print(model.productImageFile);

  if (product.product_barcode.isEmpty) errorMassages.add('بارکد وارد نشده است');
  if (product.product_category == null)
    errorMassages.add('دسته بندی انتخاب نشده');
  if (product.product_name.isEmpty) errorMassages.add('نام محصول وارد نشده');
  if (product.product_price_sell.isEmpty)
    errorMassages.add('قیمت فروش وارد نشده');
  if (product.product_count.isEmpty)
    errorMassages.add('موجودی محصول وارد نشده');
  if (product.product_size.isEmpty)
    errorMassages.add('سایزبندری محصول وارد نشده');
  if (model.productImageFile == null ) errorMassages.add('عکس محصول انتخاب نشده');

  if (errorMassages.length != 0)
    model.errorDialog(
        context: context,
        title: 'عزیزم ! خطا داری',
        desc: 'خواهش میکنم موارد رو درست کن',
        content: Container(
          height: 30.0 * (errorMassages.length.round()-1),
          child: ListView.builder(
            itemCount: errorMassages.length,
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
  else
    model.addNewProduct(product).whenComplete(() {
      if (model.productAddedToServer)
        model.successDialog(
            title: 'محصول با موفقیت ثبت شد', desc: 'خیلی متشکرم بانو' , context: context);
    });
}
