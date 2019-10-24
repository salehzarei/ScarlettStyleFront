import 'package:flutter/material.dart';
import 'package:scarlettstayle/utils/menu.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;
import '../theme/textStyle.dart';
import '../models/categoriesmodel.dart';
import '../scoped/mainscoped.dart';

class CategoryManage extends StatefulWidget {
  CategoryManage({Key key}) : super(key: key);

  _CategoryManageState createState() => _CategoryManageState();
}

class _CategoryManageState extends State<CategoryManage> {
  @override
  void initState() {
    super.initState();

    MainModel model = ScopedModel.of(context);
    model.fetchCategories();
    model.fetchProducts();
  }

  TextEditingController _categorytName = TextEditingController();
  TextEditingController _categoryDes = TextEditingController();

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
                'مدیریت دسته بندی ها',
                style: titleStyle,
              ),
            ),
            drawer: Menu(),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListView(
                children: <Widget>[
                  searchBox(),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 180,
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.transparent,
                      child: categoryList(model, context),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => addNewCategory(model),
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  Widget searchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
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
                    width: 180.0,
                    child: TextFormField(
                      style: fildInputText,
                      decoration: fildInputForm.copyWith(
                          icon: Icon(Icons.search),
                          hintText: 'جستجوی دسته بندی ...',
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
        ],
      ),
    );
  }

  Widget categoryList(MainModel model, context) {
    return model.isLoadingCategories
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: model.categoriData.length,
            itemBuilder: (context, index) {
              int productCounter = 0;
              model.productData.forEach((data) {
                if (data.product_category ==
                    model.categoriData[index].categorie_id) productCounter++;
              });

              Color randcolor =
                  Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
                      .withOpacity(1.0);
              return InkWell(
                onTap: () => editCategory(model.categoriData[index]),
                child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10.0,
                      children: <Widget>[
                        Container(height: 40, width: 8, color: randcolor),
                        Container(
                            width: 185,
                            // color: Colors.red,
                            alignment: Alignment.centerRight,
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(model.categoriData[index].categorie_name,
                                    style:
                                        titleStyle.copyWith(color: randcolor)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(model.categoriData[index].categorie_des,
                                    style: titleStyle.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal)),
                              ],
                            )),
                        Container(
                            width: 65,
                            //   color: Colors.yellow,
                            height: 55,
                            alignment: Alignment.centerLeft,
                            child: Text(" $productCounter محصول")),
                        Container(
                            width: 30,
                            alignment: Alignment.centerRight,
                            //  color: Colors.blue,
                            height: 55,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onPressed: () => deleteCategory(model,
                                  model.categoriData[index], productCounter),
                            )),
                      ],
                    )),
              );
            },
          );
  }

  editCategory(CategoriesModel categoriData) {
    _categoryDes.text = categoriData.categorie_des;
    _categorytName.text = categoriData.categorie_name;
    return showDialog(
        context: context,
        builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  backgroundColor: Colors.white,
                  title: Text(
                    'ویرایش دسته بندی',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
                  ),
                  content: Container(
                    width: 300,
                    height: 200,
                    child: ListView(children: <Widget>[
                      categorytName(),
                      categorytDes(),
                      SizedBox(
                        height: 15,
                      ),
                      button(categoriData.categorie_id)
                    ]),
                  )),
            ));
  }

  Widget categorytName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    child: Text(
                      'نام دسته',
                      style: fildTitle,
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade500,
                    width: 2,
                    height: 25,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  Container(
                    width: 130.0,
                    child: TextFormField(
                      style: fildInputText,
                      decoration: fildInputForm,
                      maxLength: 20,
                      controller: _categorytName,
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

  Widget categorytDes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    child: Text(
                      'توضیحات',
                      style: fildTitle,
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade500,
                    width: 2,
                    height: 25,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  Container(
                    width: 130.0,
                    child: TextFormField(
                      style: fildInputText,
                      decoration: fildInputForm,
                      maxLength: 20,
                      controller: _categoryDes,
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

  button(String catId) {
    MainModel model = ScopedModel.of(context);

    return RaisedButton(
      onPressed: () {
        CategoriesModel newcategory = CategoriesModel(
            categorie_des: _categoryDes.text,
            categorie_name: _categorytName.text,
            categorie_id: catId,
            categorie_state: 'true');

        model.updateCategories(newcategory).whenComplete(() {
          if (model.dataupdated)
            Navigator.pushNamed(context, '/managecategories');
        });
      },
      child: Text(
        'ثبت تغییرات',
        style: buttonText,
      ),
      color: Colors.pinkAccent,
      shape: StadiumBorder(),
    );
  }

  addNewCategory(MainModel model) {
    _categorytName.clear();
    _categoryDes.clear();

    return showDialog(
        context: context,
        builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  backgroundColor: Colors.white,
                  title: Text(
                    'ثبت یک دسته بندی جدید',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
                  ),
                  content: Container(
                    width: 300,
                    height: 200,
                    child: ListView(children: <Widget>[
                      categorytName(),
                      categorytDes(),
                      SizedBox(
                        height: 15,
                      ),
                      RaisedButton(
                        onPressed: () {
                          CategoriesModel newcategory = CategoriesModel(
                              categorie_des: _categoryDes.text,
                              categorie_name: _categorytName.text,
                              categorie_state: 'true');

                          model.addNewCategories(newcategory, context);
                        },
                        child: Text(
                          'ذخیره تغییرات',
                          style: buttonText,
                        ),
                        color: Colors.pinkAccent,
                        shape: StadiumBorder(),
                      )
                    ]),
                  )),
            ));
  }

  deleteCategory(MainModel model, CategoriesModel category, int count) {
    if (count != 0) {
      model.errorDialog(
          title: 'نمیشه حذف کنید',
          desc: 'اول باید همه محصولات رو از این دسته حذف کنید',
          context: context);
    } else
      model.deleteCategories(category.categorie_id, context).whenComplete(() {
        if (model.datadeleted)
          Navigator.pushNamed(context, '/managecategories');
      });
  }
}
