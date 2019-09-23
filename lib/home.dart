import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './utils/buttonmenu.dart';
import './utils/basketiconcount.dart';
import './utils/menu.dart';
import './models/categoriesmodel.dart';
import './collection.dart';
import './scoped/mainscoped.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    MainModel model = ScopedModel.of(context);
    if (model.isLoadingCategories && model.categoriData.length == 0) {
      model.fetchCategories().then((result) {
        setState(() {
          _isloading = model.isLoadingCategories;
        });
      });
    }

    /// if Categori data load befor . isloading = false
    setState(() {
      _isloading = model.isLoadingCategories;
    });
  }
    pageindex(){
print("CallBack");
}

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'images/header.jpg',
            fit: BoxFit.cover,
          ),
         
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomLeft,
                    colors: [Colors.grey.withOpacity(0.0), Colors.black])),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/basket'),
                  child: BasketCounter(
                      itemcount: model.productcart.length,
                      colors: Colors.white)),
              // actions: <Widget>[
              //   Center(
              //     child: Text(
              //       'Collection',
              //       style: TextStyle(fontSize: 25, color: Colors.white),
              //     ),
              //   ),
              //   InkWell(
              //       onTap: () => Container(
              //         width: 50,
              //       ),
              //       child: Icon(Icons.menu, color: Colors.white, size: 25)),
              // ],
            ),
            endDrawer: Menu(),
            body: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 2.72,
                      right: 20),
                  child: Container(
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "پیراهن اسکارلت طرح بهاری",
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text(
                            "سفارش دهید !",
                            style: TextStyle(color: Colors.white),
                            textDirection: TextDirection.rtl,
                          ),
                          color: Colors.pink.shade200,
                        )
                      ],
                    ),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.pink.shade50.withOpacity(0.7),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 5),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Container(
                                color: Colors.pink.shade300,
                                width: 5,
                                height: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "دسته بندی محصولات",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        _isloading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  itemCount: model.categoriData.length,
                                  itemBuilder: (context, index) {
                                    return card(
                                        model
                                            .categoriData[index].categorie_icon,
                                        model
                                            .categoriData[index].categorie_name,
                                        model.categoriData[index].categorie_id,
                                        model);
                                  },
                                ),
                              ),
                      ],
                    ),
                    height: 168,
                    width: double.infinity,
                  ),
                )
              ],
            ),
            bottomNavigationBar: BTNMenu(),
          ),
        ],
      );
    });
  }

  Widget card(String filename, String title, String catid, MainModel model) {
    return GestureDetector(
      onTap: () =>
          //  Navigator.pushNamed(context, '/collection', arguments: title),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Collection(
                        title: title,
                        catid: catid,
                        model: model,
                      ))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 180,
              width: 110,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
            ),
            Container(
              height: 127,
              width: 108,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://shifon.ir/tmp/cat_image/${filename}',
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 105),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                
                height: 35,
                width: 95,
              ),
            )
          ],
        ),
      ),
    );
  }
}
