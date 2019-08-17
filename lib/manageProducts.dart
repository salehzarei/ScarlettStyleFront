import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped/mainscoped.dart';
import './utils/manageProductBackDrop.dart';
import './models/productmodel.dart';
import './utils/cardsForAdmin.dart';

// https://github.com/mjohnsullivan/flutter-by-example/blob/master/16_panels/lib/complex_example.dart

class ManageProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: SafeArea(child: Panels()));
}

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);
  final id = ValueNotifier<String>("0");

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return ManageProducts(
        frontLayer: FrontPanel(
          model: model,
        ),
        backLayer: BackPanel(frontPanelOpen: frontPanelVisible, model: model),
        frontHeader: FrontPanelTitle(),
        panelVisible: frontPanelVisible,
        frontPanelOpenHeight: 40.0,
        frontHeaderHeight: 48.0,
        frontHeaderVisibleClosed: true,
      );
    });
  }
}

class FrontPanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Text(
        'انتخاب دسته بندی',
        style: Theme.of(context).textTheme.subhead,
      ),
    );
  }
}

class FrontPanel extends StatefulWidget {
  final MainModel model;

  FrontPanel({Key key, this.model}) : super(key: key);

  _FrontPanelState createState() => _FrontPanelState();
}

class _FrontPanelState extends State<FrontPanel> {
  String _selectedCat;
  Color _color;

  selectButtonColor(selectId) {
    if (_selectedCat == selectId) {
      _color = Theme.of(context).copyWith().buttonColor.withRed(250);
    } else {
      _color = Theme.of(context).copyWith().buttonColor.withGreen(250);
    }
    return _color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Theme.of(context).cardColor,
      child: Center(
        child: ListView.builder(
          itemCount: widget.model.categoriList.length,
          itemBuilder: (context, index) {
            selectButtonColor(widget.model.categoriList.keys.elementAt(index));
            return Center(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCat =
                              widget.model.categoriList.keys.elementAt(index);
                          widget.model.currentSelectedCatID = _selectedCat;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 290,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: _color),
                        padding: EdgeInsets.all(10),
                        child: Text(
                            widget.model.categoriList.values.elementAt(index)),
                      ),
                    )));
          },
        ),
      ),
    );
  }
}

class BackPanel extends StatefulWidget {
  BackPanel({@required this.frontPanelOpen, this.model});
  final ValueNotifier<bool> frontPanelOpen;
  final MainModel model;

  @override
  createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;
  String _currentId;
  List<ProductModel> _selectedProduct = [];

  @override
  initState() {
    super.initState();
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  Future _selectProducts(String catid) async {
    _selectedProduct.clear();
    // widget.model.fetchProducts();
    widget.model.productData.forEach((id) {
     if (id.product_category == catid) _selectedProduct.add(id);
    });
  }

  void _subscribeToValueNotifier() =>
      setState(() => panelOpen = widget.frontPanelOpen.value);

  /// Required for resubscribing when hot reload occurs
  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    _currentId = widget.model.currentSelectedCatID;
    _selectProducts(_currentId);
      return Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
                'مدیریت محصولات ${panelOpen ? "همه" : widget.model.categoriList[_currentId]}'),
          )),
          _selectedProduct.length == 0
              ? Center(
                  child:
                      Text("عزیزم هیچ محصولی تو این دسته بندی نیست بخدا"),
                )
              : GridView.builder(
                  shrinkWrap: true,
                                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemCount: _selectedProduct.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CardsForProductsinAdmin(
                      productmodel: _selectedProduct[index],
                    );
                  }),
          Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
            child: Text('انتخاب محصول'),
            onPressed: () {
              widget.frontPanelOpen.value = true;
            },
          ),
           RaisedButton(
            child: Text('اضافه کردن محصول '),
            onPressed: ()=>Navigator.pushNamed(context, '/addnewProduct')
          )
                ],
              )),
          // will not be seen; covered by front panel
          Center(child: Text('Bottom of Panel')),
        ]);
  }
}
