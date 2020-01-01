import 'package:flutter/material.dart';
import 'package:scarlettstayle/models/productmodel.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:scarlettstayle/theme/textStyle.dart';
import 'package:scoped_model/scoped_model.dart';

class AddToCart extends StatefulWidget {
  AddToCart({Key key}) : super(key: key);

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AddToCartDialog();
                  });
            },
            child: CircleAvatar(
              backgroundColor: Colors.pink,
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
              radius: 30,
            ),
          ),
        );
      },
    );
  }
}

class AddToCartDialog extends StatefulWidget {
  AddToCartDialog({Key key}) : super(key: key);

  @override
  _AddToCartDialogState createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  TextEditingController _productCode = TextEditingController();

  searchBox() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 61,
                  child: Text(
                    'کد محصول',
                    style: fildTitle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  color: Colors.grey.shade500,
                  width: 2,
                  height: 25,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: TextField(
                    autofocus: true,
                    style: fildInputText.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    decoration: fildInputForm,
                    maxLength: 10,
                    controller: _productCode,
                    keyboardType: TextInputType.number,
                    onSubmitted: (f) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  productShow(ProductModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'سایز',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              product.product_size,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              width: 130,
              height: 180,
              decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage('https://shifon.ir/tmp/product_image/${product.product_image}'),
                  //   fit: BoxFit.cover
                  // ),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'موجودی',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              product.product_count,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      model.productData.where((f) {
                        print(f);
                      });
                    },
                  ),
                  searchBox(),
                  //  productShow(model.productData[0]),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: 78,
              height: 78,
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 28,
                ),
                backgroundColor: Colors.pink,
              ),
            ),
          ],
        );
      },
    );
  }
}
