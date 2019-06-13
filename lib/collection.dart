import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './utils/buttonmenu.dart';
import './utils/cards.dart';
import './scoped/mainscoped.dart';
import './utils/menu.dart';

class Collection extends StatefulWidget {
  final String title, catid;
  final MainModel model;

  Collection({Key key, this.title, this.catid, this.model}) : super(key: key);

  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  bool _isloading = true;
  String _selectedCatId;

  @override
  void initState() {
    super.initState();

    /// check is Selected Data load or not ! if not load it
    /// also if page is new categorei load again with new catid

    if (widget.model.isLoadingSelectedProduct &&
            widget.model.selectedProductData.length == 0 ||
        widget.catid != widget.model.currentSelectedCatID) {
      widget.model.fetchSelectedProducts(widget.catid).then((result) {
        setState(() {
          _isloading = widget.model.isLoadingSelectedProduct;
          _selectedCatId = widget.model.currentSelectedCatID;
        });
      });
    }

    /// if Selected data load befor . isloading = false
    setState(() {
      _isloading = widget.model.isLoadingSelectedProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade700),
            onPressed: () => Navigator.pushNamed(context, '/'),
          ),
          title: Text(widget.title,
              style: TextStyle(fontSize: 20, color: Colors.grey.shade700)),
        ),
        endDrawer: Menu(),
        backgroundColor: Colors.pink.shade50,
        bottomNavigationBar: BTNMenu(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : widget.model.selectedProductData.length == 0
                  ? Center(
                      child:
                          Text("عزیزم هیچ محصولی تو این دسته بندی نیست بخدا"),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                      itemCount: model.selectedProductData.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          productmodel: model.selectedProductData[index],
                        );
                      }),
        ),
      );
    });
  }
}
