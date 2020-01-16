import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scarlettstayle/functions/chekProducts.dart';
import 'package:scarlettstayle/models/productmodel.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:scarlettstayle/theme/textStyle.dart';
import 'package:scarlettstayle/utils/menu.dart';
import 'package:scoped_model/scoped_model.dart';

class EditProducts extends StatefulWidget {
  final ProductModel product;

  EditProducts({Key key, this.product}) : super(key: key);

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  Widget divider() {
    return Container(
      color: Colors.grey.shade500,
      width: 2,
      height: 25,
      margin: EdgeInsets.symmetric(horizontal: 5),
    );
  }

  Widget fildTitles(String title) {
    return SizedBox(
      width: 65,
      child: Text(
        title,
        style: fildTitle,
      ),
    );
  }

  TextEditingController _productCode = TextEditingController();
  TextEditingController _productName = TextEditingController();
  TextEditingController _productCount = TextEditingController();
  TextEditingController _productSize = TextEditingController();
  TextEditingController _productDes = TextEditingController();
  List<DropdownMenuItem> _catListMenu = [];
  String _catSelectedID;
  bool _imageLoading = false;
  bool _catLoading = true;

  var _productBuyPriceController = MoneyMaskedTextController(
    precision: 0,
    thousandSeparator: '.',
    decimalSeparator: '',
  );
  var _productSalePriceController = MoneyMaskedTextController(
    precision: 0,
    thousandSeparator: '.',
    decimalSeparator: '',
  );

  @override
  void initState() {
    super.initState();
    _productCode.text = widget.product.product_barcode;
    _productName.text = widget.product.product_name;
    _productSalePriceController.text = widget.product.product_price_sell;
    _productBuyPriceController.text = widget.product.product_price_buy;
    _productCount.text = widget.product.product_count;
    _productSize.text = widget.product.product_size;
    _productDes.text = widget.product.product_des;
    _catSelectedID = widget.product.product_category;

    MainModel model = ScopedModel.of(context);
    model.fetchCategories().whenComplete(() {
      if (model.categoriData.length != 0) {
        setState(() {
          _catListMenu = model.categoriData.map((cat) {
            return DropdownMenuItem(
              value: cat.categorie_id,
              child: Text(
                cat.categorie_name,
                style: fildInputText,
              ),
            );
          }).toList();
          _catLoading = false;
        });
      }
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.purple),
              centerTitle: true,
              title: Text(
                'ویرایش محصول',
                style: titleStyle,
              ),
            ),
            drawer: Menu(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ListView(
                children: <Widget>[
                  ///// دسته بندی
                  productCategory(),
                  ///// کد محصول
                  productCode(model),
                  ///// نام محصول
                  productName(),
                  ///// قیمت خرید
                  productBuyPrice(),
                  ///// قیمت فروش
                  productSalePrice(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ////  موجودی محصول
                          productCount(),
                          //// سایز محصول
                          productSize(),
                          //// تصویر محصول
                          productImage(model),
                        ],
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        width: 145,
                        height: 175,
                        child: _imageLoading
                            ? SpinKitFadingGrid(
                                color: Colors.blueGrey,
                                size: 120,
                              )
                            : null,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://shifon.ir/tmp/product_image/" +
                                      widget.product.product_image),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ],
                  ),
                  ///// توضیحات محصول
                  productDes(),

                  Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 10,
                      ),
                      child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  // ProductModel newproduct = ProductModel(
                                  //   product_barcode: _productCode.text,
                                  //   product_name: _productName.text,
                                  //   product_category: _catSelectedID,
                                  //   product_count: _productCount.text,
                                  //   product_des: _productDes.text,
                                  //   product_price_sell:
                                  //       _productSalePriceController.text.isEmpty
                                  //           ? '0'
                                  //           : _productSalePriceController
                                  //               .numberValue
                                  //               .round()
                                  //               .toString(),
                                  //   product_price_buy:
                                  //       _productBuyPriceController.text.isEmpty
                                  //           ? '0'
                                  //           : _productBuyPriceController
                                  //               .numberValue
                                  //               .round()
                                  //               .toString(),
                                  //   product_size: _productSize.text,
                                  // );
                                  // checkProducts(context, newproduct, model);
                                },
                                child: Text(
                                  'ثبت تغییرات',
                                  style: buttonText,
                                ),
                                color: Colors.greenAccent.shade700,
                                shape: StadiumBorder(),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  model.deleteProduct(widget.product.product_id, widget.product.product_image, context);
                                },
                                child: Text(
                                  'حذف محصول',
                                  style: buttonText,
                                ),
                                color: Colors.pinkAccent,
                                shape: StadiumBorder(),
                              ),
                            ],
                          )))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget productCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  fildTitles('دسته بندی'),
                  divider(),
                  SizedBox(
                      width: 180.0,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: _catListMenu,
                          isExpanded: true,
                          value: _catSelectedID,
                          hint: _catLoading
                              ? Text(
                                  ' کمی صبر کنید ...',
                                  style: TextStyle(color: Colors.redAccent),
                                )
                              : Text(_catSelectedID),
                          onChanged: (newVal) {
                            setState(() {
                              _catSelectedID = newVal;
                            });
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productCode(MainModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  fildTitles('کد محصول'),
                  divider(),
                  SizedBox(
                    width: 120.0,
                    child: TextFormField(
                      style: fildInputText,
                      controller: _productCode,
                      decoration: fildInputForm,
                      maxLength: 10,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onFieldSubmitted: (code) async {
                        setState(() {
                          model.barcode = code;
                        });

                        model.checkProduct(context).then((val) {
                          if (!val) _productCode.clear();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.camera_alt),
              iconSize: 30,
              color: Colors.grey.shade500,
              onPressed: () {
                model.scanBarcode().whenComplete(() {
                  model.checkProduct(context).then((val) {
                    if (!val)
                      _productCode.clear();
                    else
                      setState(() {
                        _productCode.text = model.barcode;
                      });
                  });
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget productName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  fildTitles('نام محصول'),
                  divider(),
                  SizedBox(
                    width: 180.0,
                    child: TextFormField(
                      style: fildInputText,
                      decoration: fildInputForm,
                      maxLength: 28,
                      controller: _productName,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productBuyPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  fildTitles('فی خرید'),
                  divider(),
                  SizedBox(
                    width: 180.0,
                    child: TextFormField(
                      style: fildInputText,
                      controller: _productBuyPriceController,
                      decoration: fildInputForm.copyWith(
                        suffixText: 'تومان',
                      ),
                      maxLength: 9,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productSalePrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  fildTitles('فی فروش'),
                  divider(),
                  SizedBox(
                    width: 180.0,
                    child: TextFormField(
                      style: fildInputText,
                      controller: _productSalePriceController,
                      decoration: fildInputForm.copyWith(suffixText: 'تومان'),
                      maxLength: 9,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                fildTitles('موجودی'),
                divider(),
                SizedBox(
                  width: 40.0,
                  child: TextFormField(
                    style: fildInputText,
                    decoration: fildInputForm,
                    maxLength: 2,
                    controller: _productCount,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productSize() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                fildTitles('سایزبندی'),
                divider(),
                SizedBox(
                  width: 40.0,
                  child: TextFormField(
                    style: fildInputText,
                    decoration: fildInputForm,
                    maxLength: 2,
                    controller: _productSize,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productImage(MainModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 50.0,
                  child: IconButton(
                    icon: Icon(Icons.photo_camera),
                    iconSize: 30,
                    color: Colors.grey.shade500,
                    onPressed: () {
                      setState(() {
                        _imageLoading = true;
                      });
                      model.getImageCamera().whenComplete(() {
                        setState(() {
                          _imageLoading = false;
                        });
                      });
                    },
                  ),
                ),
                divider(),
                SizedBox(
                  width: 50.0,
                  child: IconButton(
                    icon: Icon(Icons.photo_library),
                    iconSize: 30,
                    color: Colors.grey.shade500,
                    onPressed: () {
                      setState(() {
                        _imageLoading = true;
                      });
                      model.getImageGallery().whenComplete(() {
                        setState(() {
                          _imageLoading = false;
                        });
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productDes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  fildTitles('توضیحات'),
                  divider(),
                  SizedBox(
                    width: 180.0,
                    child: TextFormField(
                      style: fildInputText,
                      decoration: fildInputForm,
                      maxLength: 30,
                      controller: _productDes,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
