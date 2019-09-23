import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            'افزودن محصول جدید',
            style: titleStyle,
          ),
        ),
        drawer: Menu(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                autofocus: true,
                                maxLength: 10,
                                onFieldSubmitted: (f){
                                  FocusScope.of(context).requestFocus(_productNameFocus);
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
                        onPressed: () {},
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                maxLength: 28,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            fildTitles('دسته بندی'),
                            divider(),
                            SizedBox(
                              width: 180.0,
                              child: TextFormField(
                                style: fildInputText,
                                decoration: fildInputForm,
                                maxLength: 28,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                maxLength: 28,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (f){
                                  FocusScope.of(context).requestFocus(_productSalePriceFocus);
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                                focusNode: _productSalePriceFocus,
                                maxLength: 28,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (f){
                                  FocusScope.of(context).requestFocus(_productCountFocus);
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
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  fildTitles('موجودی'),
                                  divider(),
                                  SizedBox(
                                    width: 40.0,
                                    child: TextFormField(
                                      style: fildInputText,
                                      decoration: fildInputForm,
                                      focusNode: _productCountFocus,
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                onFieldSubmitted: (f){
                                  FocusScope.of(context).requestFocus(_productSizeFocus);
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
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  fildTitles('سایزبندی'),
                                  divider(),
                                  SizedBox(
                                    width: 40.0,
                                    child: TextFormField(
                                      style: fildInputText,
                                      decoration: fildInputForm,
                                      focusNode: _productSizeFocus,
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                onFieldSubmitted: (f){
                                  FocusScope.of(context).requestFocus(_productDesFocus);
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
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 50.0,
                                    child: IconButton(
                                      icon: Icon(Icons.photo_camera),
                                      iconSize: 30,
                                      color: Colors.grey.shade500,
                                      onPressed: () {},
                                    ),
                                  ),
                                  divider(),
                                  SizedBox(
                                    width: 50.0,
                                    child: IconButton(
                                      icon: Icon(Icons.photo_library),
                                      iconSize: 30,
                                      color: Colors.grey.shade500,
                                      onPressed: () {},
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/noimage.png'), fit: BoxFit.cover),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                      onPressed: () {},
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
    );
  }
}
