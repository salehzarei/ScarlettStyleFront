import 'package:flutter/material.dart';
import 'package:scarlettstayle/utils/menu.dart';
import 'package:scarlettstayle/widgets/cards.dart';
import 'package:scoped_model/scoped_model.dart';
import '../theme/textStyle.dart';
import '../scoped/mainscoped.dart';

class ProductManage extends StatefulWidget {
  ProductManage({Key key}) : super(key: key);

  _ProductManageState createState() => _ProductManageState();
}

class _ProductManageState extends State<ProductManage> {
  @override
  void initState() {
    super.initState();

    MainModel model = ScopedModel.of(context);
    model.fetchCategories();
    model.fetchProducts();
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
                'مدیریت محصولات',
                style: titleStyle,
              ),
            ),
            drawer: Menu(),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
              child: ListView(
                children: <Widget>[
                  searchBox(model),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 180,
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.transparent,
                      child: productList(model, context),
                      alignment: Alignment.centerLeft,
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()=>Navigator.pushNamed(context, '/addnewProduct'),
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  Widget searchBox(MainModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      style: fildInputText,
                      decoration: fildInputForm.copyWith(
                          icon: Icon(Icons.search),
                          hintText: 'جستجوی مصحول، نام، کد ...',
                          hintMaxLines: 1,
                          hintStyle: TextStyle(
                              fontSize: 15, color: Colors.grey.shade500)),
                      maxLength: 28,
                      keyboardType: TextInputType.text,
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
                  print(model.barcode);
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget productList(MainModel model, context) {
    return model.isLoadingAllProduct
        ? Center(
            child: CircularProgressIndicator(),
          )
        : GridView.builder(
            itemCount: model.productData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 5.0 / 8.0,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                productmodel: model.productData[index],
              );
            },
          );
  }
}
