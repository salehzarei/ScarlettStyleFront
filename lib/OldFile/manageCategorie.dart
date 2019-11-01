import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scarlettstayle/models/categoriesmodel.dart';
import 'package:scarlettstayle/scoped/mainscoped.dart';
import 'package:scoped_model/scoped_model.dart';


bool picchange = false;

class ManageCategories extends StatefulWidget {
  final MainModel model;

  ManageCategories({Key key, this.model}) : super(key: key);

  _ManageCategoriesState createState() => _ManageCategoriesState();
}

TextEditingController _catgoreiname = TextEditingController();
TextEditingController _catgoreides = TextEditingController();
bool _refreshpage = false;
int _itemcount;
File catimage;

class _ManageCategoriesState extends State<ManageCategories> {
  @override
  void initState() {
    super.initState();
    _itemcount = widget.model.categoriList.length;
    print("ReadFirst ItemCont : $_itemcount");
  }

  Future<Null> _showdialog(
      BuildContext context, MainModel model, CategoriesModel catemodel) async {
    bool _deletesate = false;

    if (catemodel != null) {
      _catgoreiname.text = catemodel.categorie_name;
      _catgoreides.text = catemodel.categorie_des;
      _deletesate = true;
    }

    await showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  height: 350,
                  width: 200,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            CatImage(
                                model: model,
                                catmodel: catemodel,
                                isEdit: _deletesate),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: ListView(
                                children: <Widget>[
                                  TextField(
                                    decoration: InputDecoration(
                                        hintText: 'نام دسته بندی',
                                        counterText: ''),
                                    maxLength: 25,
                                    controller: _catgoreiname,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                        hintText: 'توضیحات', counterText: ''),
                                    maxLength: 40,
                                    controller: _catgoreides,
                                  )
                                ],
                                shrinkWrap: true,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FlatButton.icon(
                                  color: Colors.green.shade300,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.grey.shade700,
                                  ),
                                  label: Text('ذخیره'),
                                  textColor: Colors.grey.shade700,
                                  onPressed: () {
                                    if (_catgoreiname.text.isNotEmpty) {
                                      CategoriesModel newcat = CategoriesModel(
                                        categorie_name: _catgoreiname.text,
                                        categorie_des: _catgoreides.text,
                                        categorie_state: 'true',
                                      );

                                      catimage = model.cateImageFile;
                                      if (!_deletesate) {
                                      //  addnewcat(model, newcat, catimage);
                                      } else {
                                        if (!picchange) {
                                          catimage = null ;
                                        }
                                        print("PicChange : $picchange");
                                        CategoriesModel editcat =
                                            CategoriesModel(
                                          categorie_id: catemodel.categorie_id,
                                          categorie_name: _catgoreiname.text,
                                          categorie_des: _catgoreides.text,
                                          categorie_icon: catemodel.categorie_icon,
                                          categorie_state: 'true',
                                        );
                                       // updatewcat(model, editcat, catimage);
                                      }

                                      setState(() {
                                        _refreshpage = true;
                                      });
                                    } else {
                                      print("Noting to add");
                                    }
                                  },
                                ),
                                FlatButton.icon(
                                    color: Colors.red.shade100,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.grey.shade700,
                                    ),
                                    label: Text('بیخیال !'),
                                    textColor: Colors.grey.shade700,
                                    onPressed: () {
                                      _catgoreides.clear();

                                      _catgoreiname.clear();

                                      Navigator.pop(context);
                                    }),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                            visible: _deletesate,
                            child: IconButton(
                              onPressed: () {
                               // deletecat(model, catemodel);
                                setState(() {
                                  _refreshpage = true;
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.grey.shade700,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  // Future deletecat(MainModel model, CategoriesModel cat) async {
  //   try {
  //     Navigator.pop(context);
  //     await model
  //         .deleteCategories(cat.categorie_id, cat.categorie_icon)
  //         .whenComplete(() {
  //       if (model.datadeleted) refresh(model);
  //     });
  //   } finally {
  //     _catgoreides.clear();
  //     _catgoreiname.clear();
  //   }
  // }

  // Future updatewcat(MainModel model, CategoriesModel cat, image) async {
  //   try {
  //     Navigator.pop(context);
  //     await model.updateCategories(cat, image).whenComplete(() {
  //       if (model.dataupdated) refresh(model);
  //     });
  //   } finally {
  //     _catgoreides.clear();
  //     _catgoreiname.clear();
  //   }
  // }

  // Future addnewcat(MainModel model, CategoriesModel newcat, image) async {
  //   try {
  //     Navigator.pop(context);
  //     await model.addNewCategories(newcat).whenComplete(() {
  //       print(model.dataAdded);
  //       if (model.dataAdded) refresh(model);
  //     });
  //   } finally {
  //     _catgoreides.clear();
  //     _catgoreiname.clear();
  //   }
  // }

  Future refresh(MainModel model) async {
    print("Run refresh");
    await model.fetchCategories().whenComplete(() {
      setState(() {
        _itemcount = model.categoriList.length;
        print("itemconut after FetchCategori : $_itemcount");
        _refreshpage = false;
      });
    });
  }

  cattile(BuildContext context, MainModel model, int index) {
    int categorieitamcount = 0;

    ///چک کردن اینکه چه تعداد محصول در یک دسته بندی قراردارد
    for (int i = 0; i < model.productData.length; i++) {
      if (model.productData[i].product_category ==
          model.categoriData[index].categorie_id)
        categorieitamcount = categorieitamcount + 1;
    }
    return GestureDetector(
      onTap: () => _showdialog(context, model, model.categoriData[index]),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white30),
            child: ListTile(
              dense: true,
              title: Text(model.categoriData[index].categorie_name,
                  style: Theme.of(context).textTheme.headline),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(model.categoriData[index].categorie_des,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle
                        .copyWith(color: Colors.grey.shade600)),
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://mashhadsafari.com/tmp/cat_image/${model.categoriData[index].categorie_icon}'),
                radius: 25,
              ),
              //نمایش تعداد محصولات این دسته بندی
              trailing: Text('${categorieitamcount} محصول '),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              'مدیریت دسته بندی',
              style: Theme.of(context).textTheme.title,
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
          body: Builder(
            builder: (context) {
              return Center(
                child: _refreshpage
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "چند لحظه صبر کنی بد نیست ....",
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: _itemcount,
                        itemBuilder: (context, index) {
                          return cattile(context, model, index);
                        },
                      ),
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                  backgroundColor: Colors.pink.shade500,
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _showdialog(context, model, null);
                  });
            },
          ),
        );
      },
    );
  }
}

class CatImage extends StatefulWidget {
  final MainModel model;
  final CategoriesModel catmodel;
  final bool isEdit;

  CatImage({Key key, this.model, this.catmodel, this.isEdit}) : super(key: key);

  _CatImageState createState() => _CatImageState();
}

class _CatImageState extends State<CatImage> {
  String catimage;
  bool _isedit;
  bool _ispicchange;

  _showpicture(bool isedit) {
    if (isedit) {
      print("ISChange:$_ispicchange");
      if (!_ispicchange) {
        print("1");
        setState(() {
          picchange = false;
        });
        return NetworkImage(
            'https://mashhadsafari.com/tmp/cat_image/${catimage}');
      } else {
        print("2");
         setState(() {
          picchange = true;
        });
        return FileImage(widget.model.cateImageFile);
      }
    } else {
      print("3");
      widget.model.cateImageFile = null;
      return AssetImage('images/noimage.png');
    }
  }

  @override
  void initState() {
    super.initState();
    _isedit = widget.isEdit;
    _ispicchange = false;
    if (_isedit) {
      print(widget.catmodel.categorie_icon);
      catimage = widget.catmodel.categorie_icon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        height: 150,
      ),
      Container(
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.pink.shade100),
      ),
      Positioned(
        top: 30,
        left: 94,
        child: Container(
          height: 95,
          width: 95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: Colors.pink.shade200,
                  width: 2,
                  style: BorderStyle.solid),
              image: DecorationImage(
                  image: _showpicture(_isedit), fit: BoxFit.fitHeight)),
        ),
      ),
      Positioned(
          top: 110,
          left: 94,
          child: FlatButton(
            child: Text('تغییر تصویر'),
            textColor: Colors.grey.shade700,
            onPressed: () {
              widget.model.getImageGallery().then((result) {
                setState(() {
                  _isedit = true;
                  _ispicchange = true;
                });
              });
            },
          ))
    ]);
  }
}
