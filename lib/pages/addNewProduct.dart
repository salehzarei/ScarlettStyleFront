import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scarlettstayle/models/productmodel.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/textStyle.dart';
import '../utils/menu.dart';

class AddNewProduct extends StatefulWidget {
  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
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

  final FocusNode _productNameFocus = FocusNode();
  final FocusNode _productBuyPriceFocus = FocusNode();
  final FocusNode _productSalePriceFocus = FocusNode();
  final FocusNode _productCountFocus = FocusNode();
  final FocusNode _productSizeFocus = FocusNode();
  final FocusNode _productDesFocus = FocusNode();

  TextEditingController _barcode = TextEditingController()..text = 'بدون کد';
  TextEditingController _name = TextEditingController();
  TextEditingController _buyPrice = TextEditingController();
  TextEditingController _salePrice = TextEditingController();
  TextEditingController _count = TextEditingController();
  TextEditingController _size = TextEditingController();
  TextEditingController _des = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem> _catListMenu = [];
  String _catSelectedID;
  bool _loadingImage = false;

  @override
  void initState() {
    super.initState();
    MainModel model = ScopedModel.of(context);
    model.fetchCategories().whenComplete(() {
      if (model.categoriData.length != 0) {
        setState(() {
          _catListMenu = model.categoriData.map((cat) {
            return DropdownMenuItem(
              value: cat.categorie_id,
              child: Text(cat.categorie_name),
            );
          }).toList();
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
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.purple),
              centerTitle: true,
              title: Text(
                'افزودن محصول جدید',
                style: titleStyle,
              ),
            ),
            drawer: Menu(),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    ///// کد محصول
                    Padding(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  fildTitles('کد محصول'),
                                  divider(),
                                  SizedBox(
                                    width: 120.0,
                                    child: TextFormField(
                                      style: fildInputText,
                                      decoration: fildInputForm,
                                      controller: _barcode,
                                      validator: (val) {
                                        if (val.isEmpty) {}
                                        return null;
                                      },
                                      autofocus: true,
                                      maxLength: 10,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context)
                                            .requestFocus(_productNameFocus);
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
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
                                  setState(() {
                                    _barcode.text = model.barcode;
                                  });
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    ///// نام محصول
                    Padding(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  fildTitles('نام محصول'),
                                  divider(),
                                  SizedBox(
                                    width: 180.0,
                                    child: TextFormField(
                                      style: fildInputText,
                                      focusNode: _productNameFocus,
                                      decoration: fildInputForm,
                                      controller: _name,
                                      maxLength: 28,
                                      validator: (val) {
                                        if (val.isEmpty) {}
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///// دسته بندی
                    Padding(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
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
                                          value: _catSelectedID,
                                          hint: Text(
                                            'یک دسته را انتخاب کنید',
                                            textDirection: TextDirection.rtl,
                                          ),
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
                    ),
                    ///// قیمت خرید
                    Padding(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  fildTitles('فی خرید'),
                                  divider(),
                                  SizedBox(
                                    width: 180.0,
                                    child: TextFormField(
                                      style: fildInputText,
                                      decoration: fildInputForm,
                                      focusNode: _productBuyPriceFocus,
                                      controller: _buyPrice,
                                      maxLength: 28,
                                      validator: (val) {
                                        if (val.isEmpty) {}
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context).requestFocus(
                                            _productSalePriceFocus);
                                      },
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///// قیمت فروش
                    Padding(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  fildTitles('فی فروش'),
                                  divider(),
                                  SizedBox(
                                    width: 180.0,
                                    child: TextFormField(
                                      style: fildInputText,
                                      decoration: fildInputForm,
                                      controller: _salePrice,
                                      focusNode: _productSalePriceFocus,
                                      maxLength: 28,
                                      validator: (val) {
                                        if (val.isEmpty) {}
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (f) {
                                        FocusScope.of(context)
                                            .requestFocus(_productCountFocus);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///// قیمت فروش
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        fildTitles('موجودی'),
                                        divider(),
                                        SizedBox(
                                          width: 40.0,
                                          child: TextFormField(
                                            style: fildInputText,
                                            decoration: fildInputForm,
                                            focusNode: _productCountFocus,
                                            controller: _count,
                                            maxLength: 2,
                                            validator: (val) {
                                              if (val.isEmpty) {}
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (f) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _productSizeFocus);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        fildTitles('سایزبندی'),
                                        divider(),
                                        SizedBox(
                                          width: 40.0,
                                          child: TextFormField(
                                            style: fildInputText,
                                            decoration: fildInputForm,
                                            focusNode: _productSizeFocus,
                                            controller: _size,
                                            maxLength: 2,
                                            validator: (val) {
                                              if (val.isEmpty) {}
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (f) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _productDesFocus);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 50.0,
                                          child: IconButton(
                                            icon: Icon(Icons.photo_camera),
                                            iconSize: 30,
                                            color: Colors.grey.shade500,
                                            onPressed: () {
                                              setState(() {
                                                _loadingImage = true;
                                              });
                                              model
                                                  .getImageCamera()
                                                  .whenComplete(() {
                                                setState(() {
                                                  _loadingImage = false;
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
                                              model.getImageGallery();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 3),
                          width: 145,
                          height: 175,
                          child: _loadingImage
                              ? SpinKitFadingGrid(
                                  color: Colors.blueGrey,
                                  size: 120,
                                )
                              : null,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: model.cateImageFile == null
                                    ? AssetImage('images/noimage.png')
                                    : FileImage(model.cateImageFile),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ],
                    ),
                    ///// قیمت خرید
                    Padding(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
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
                                      validator: (val) {
                                        if (val.isEmpty) {}
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      focusNode: _productDesFocus,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 60,
                        ),
                        child: Container(
                          height: 40,
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                               //_formKey.currentState.save();
                                ProductModel newproduct = ProductModel(
                                    product_name: _name.text,
                                    product_price_buy: _buyPrice.text);
                                model
                                    .addNewProduct(newproduct)
                                    .whenComplete(() {
                                  model.successDialog(
                                      context: context,
                                      title: 'محصول با موفقیت ذخیره شد',
                                      desc: ' کد محصول ' + _barcode.text);
                                });
                              } else {
                                print('object');
                              }
                            },
                            child: Text(
                              'ثبت محصول',
                              style: buttonText,
                            ),
                            color: Colors.pinkAccent,
                            shape: StadiumBorder(),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
