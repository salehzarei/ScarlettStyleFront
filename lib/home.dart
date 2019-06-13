import 'package:flutter/material.dart';
import './utils/buttonmenu.dart';
import './utils/basketiconcount.dart';
import './utils/menu.dart';
import './models/categoriesmodel.dart';
import './collection.dart';
import './scoped/mainscoped.dart';

class Home extends StatefulWidget {
  final MainModel model;

  Home({Key key, this.model}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    /// check is Categori Data load or not ! if not load it
    if (widget.model.isLoadingCategories &&
        widget.model.categoriData.length == 0) {
      widget.model.fetchCategories().then((result) {
        setState(() {
          _isloading = widget.model.isLoadingCategories;
        });
      });
    }
    /// if Categori data load befor . isloading = false
    setState(() {
      _isloading = widget.model.isLoadingCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    itemcount: widget.model.productcart.length,
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
                padding: EdgeInsets.only(top: 150, right: 20),
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
                            fontSize: 33,
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
                  height: 180,
                  width: 250,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Container(
                  color: Colors.pink.shade50,
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
                              "مدل های پر طرفدار",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
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
                                itemCount: widget.model.categoriData.length,
                                itemBuilder: (context, index) {
                                  return card(
                                      widget.model.categoriData[index]
                                          .categorie_icon,
                                      widget.model.categoriData[index]
                                          .categoie_name,
                                      widget.model.categoriData[index]
                                          .categorie_id);
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
  }

  Widget card(String filename, String title, String catid) {
    return GestureDetector(
      onTap: () =>
          //  Navigator.pushNamed(context, '/collection', arguments: title),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Collection(
                        title: title,
                        catid: catid,
                        model: widget.model,
                      ))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 180,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.white),
            ),
            Container(
              height: 120,
              width: 90,
              child: Image.network(
                'https://shifon.ir/tmp/cat_image/${filename}',
                fit: BoxFit.cover,
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 108),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                color: Colors.white70,
                height: 20,
                width: 90,
              ),
            )
          ],
        ),
      ),
    );
  }
}
