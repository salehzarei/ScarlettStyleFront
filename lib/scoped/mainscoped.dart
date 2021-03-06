import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scarlettstayle/models/customermodel.dart';
import 'package:scarlettstayle/models/ordermodel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import '../models/categoriesmodel.dart';
import '../models/productmodel.dart';

class MainModel extends Model {
  List<CategoriesModel> categoriData = [];
  List<ProductModel> selectedProductData = [];
  List<ProductModel> productData = [];
  List<CustomerModel> customers = [];
  List<OrderModel> orders = [];
  Map<int, ProductModel> productcart = {};
  Map<String, String> categoriList = {};
  String barcode = '';

  bool isLoadingCategories = true;
  bool isLoadingProductData = true;
  bool isLoadingAllProduct = true;
  bool isLoadingSelectedProduct = true;
  bool productAddedToServer = false;

  bool dataAdded = true;
  bool datadeleted = false;
  bool dataupdated = false;

  String currentSelectedCatID;
  File cateImageFile;
  File productImageFile;

//// fix Price ////
  fixPrice(String price) {
    return MoneyMaskedTextController(
            precision: 0,
            thousandSeparator: '.',
            decimalSeparator: '',
            initialValue: double.parse(price))
        .text;
  }

  Future successDialog({context, title, desc}) async {
    return Alert(
        context: context,
        title: title,
        type: AlertType.success,
        desc: desc,
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pushNamed(context, '/addnewProduct'),
            child: Text(
              "+ ?????????? ????????",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pushNamed(context, '/manageproducts'),
            color: Colors.redAccent,
            child: Text(
              "???????? ??????????????",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

  Future errorDialog({context, title, desc, content}) async {
    return Alert(
        context: context,
        title: title,
        type: AlertType.error,
        desc: desc,
        content: content,
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.redAccent,
            child: Text(
              "?????????? ????????",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

//--Scan Barcode --//
  Future<void> scanBarcode() async {
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "???? ????????", true, ScanMode.BARCODE);
    } on PlatformException {
      barcode = '?????????? ???????????? ??????';
    }
  }

  showProsses(BuildContext context) {
    {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: Colors.black87.withOpacity(0.5),
              elevation: 0.0,
              content: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        ' ... ???? ???????? ?????? ????????',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    ]),
              )));
    }
  }

//---fetch All Categories From server---//
  Future fetchCategories() async {
    Response response;
    Dio dio = Dio();
    categoriData.clear();
    isLoadingCategories = true;
    notifyListeners();
    response = await dio.get('https://shifon.ir/tmp/getcategories.php');
    categoriData = (json.decode(response.data) as List)
        .map((i) => CategoriesModel.catjson(i))
        .toList();
    isLoadingCategories = false;
    notifyListeners();
    return categoriData;
  }

  //---fetch All Customers From server---//
  Future fetchCustomer() async {
    customers.clear();
    notifyListeners();
    final response = await rootBundle.loadString('jsons/sampleCustomer.json');
    customers = (json.decode(response) as List)
        .map((i) => CustomerModel.customerJson(i))
        .toList();

    notifyListeners();
    return null;
  }

  //---fetch All Orders From server---//
  Future fetchOrders() async {
    orders.clear();
    notifyListeners();
    final response = await rootBundle.loadString('jsons/sampleOrder.json');
    orders = (json.decode(response) as List)
        .map((i) => OrderModel.orderJson(i))
        .toList();
    print(orders[0].productList[1].product_name);
    notifyListeners();
    return null;
  }

//---fetch All Products From server---//
  Future fetchProducts() async {
    productData.clear();
    isLoadingAllProduct = true;
    notifyListeners();
    final response = await http.get('https://shifon.ir/tmp/getproducts.php');
    productData = (json.decode(response.body) as List)
        .map((p) => ProductModel.proJson(p))
        .toList();
    isLoadingAllProduct = false;
    notifyListeners();
    return productData;
  }

  ///-- Add New Category -- ///
  Future addNewCategories(
      CategoriesModel newCategorie, BuildContext context) async {
    showProsses(context);
    dataAdded = false;
    notifyListeners();
    Response response;
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      "categorie_name": newCategorie.categorie_name,
      "categorie_des": newCategorie.categorie_des,
      "categorie_icon": "noimage.png",
      "categorie_state": newCategorie.categorie_state
    });

    response =
        await dio.post("https://shifon.ir/tmp/addcategory.php", data: formData);
    if (response.statusCode == 200) {
      print("Upload Data Ok");
      dataAdded = true;
      notifyListeners();
      Navigator.pushNamed(context, '/managecategories');
    } else {
      print("Error to Upload Data:${response.statusCode} ");
    }

    return dataAdded;
  }

//// Add New Product ////
  Future addNewProduct(ProductModel newProduct, BuildContext context) async {
    
    Dio dio = Dio();
    Response response;
    FormData formData = FormData.fromMap({
      "product_name": newProduct.product_name,
      "product_category": newProduct.product_category,
      "product_des": newProduct.product_des,
      "product_size": newProduct.product_size,
      "product_barcode": newProduct.product_barcode,
      "product_count": newProduct.product_count,
      "product_price_buy": newProduct.product_price_buy,
      "product_price_sell": newProduct.product_price_sell,
      "product_image": await MultipartFile.fromFile(productImageFile.path,
          filename: basename(productImageFile.path))
    });
    response =
        await dio.post("https://shifon.ir/tmp/addproducts.php", data: formData);
    if (response.statusCode == 200) {
      productAddedToServer = true;
      productImageFile.writeAsStringSync('');
      notifyListeners();
    } else {
      print("Error to Upload Data:${response.statusCode} ");
      productAddedToServer = false;
      notifyListeners();
    }
  }

  Future<bool> checkProduct(BuildContext context) async {
    var response = await http.post('http://shifon.ir/tmp/checkproduct.php',
        body: {'product_barcode': barcode});
    if (response.statusCode == 200 && response.body != '[]') {
      Map jjson = json.decode(response.body);
      ProductModel product = ProductModel.proJson(jjson);
      if (product.product_barcode == barcode)
        errorDialog(
            context: context,
            title: '???? ???????? ! ?????? ???? ???????? ?????? ??????',
            desc: '???????? ???? ?????????? ???????? ?????? ????');
      return false;
    } else
      return true;
  }

  Future updateCategories(
      CategoriesModel newCategorie, BuildContext context) async {
    showProsses(context);
    print(newCategorie.categorie_id);
    print(newCategorie.categorie_name);
    print(newCategorie.categorie_des);
    print(newCategorie.categorie_state);
    print(newCategorie.categorie_icon);
    Dio dio = Dio();
    Response response;
    dataupdated = false;
    notifyListeners();
    if (newCategorie.categorie_icon == null) {
      FormData formData = FormData.fromMap({
        "categorie_id": newCategorie.categorie_id,
        "categorie_name": newCategorie.categorie_name,
        "categorie_des": newCategorie.categorie_des,
        "categorie_state": newCategorie.categorie_state,
      });
      response = await dio.post("https://shifon.ir/tmp/editcategory.php",
          data: formData);

      if (response.statusCode == 200) {
        print("Edit Data Ok");
        dataupdated = true;
        notifyListeners();
        Navigator.pushNamed(context, '/managecategories');
      } else {
        print("Error to Edit Data:${response.statusCode} ");
      }
    }
  }

// delete Categori with Picture file
  Future deleteCategories(String id, BuildContext context) async {
    datadeleted = false;

    return Alert(
        context: context,
        title: '?????????? ?????????? ???????? ?????? ??',
        type: AlertType.warning,
        buttons: [
          DialogButton(
            onPressed: () async {
              showProsses(context);
              var response = await http.post(
                  "https://shifon.ir/tmp/deletecategory.php",
                  body: {'categorie_id': id});
              if (response.statusCode == 200) {
                datadeleted = true;
                notifyListeners();
                Navigator.pushNamed(context, '/managecategories');
              }
            },
            child: Text(
              "?????? ??????????",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.redAccent,
            child: Text(
              "???????????? ?????? ",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

  // delete Categori with Picture file
  Future deleteProduct(String id, String image, BuildContext context) async {
    datadeleted = false;

    return Alert(
        context: context,
        title: '?????????? ?????????? ???????? ?????? ??',
        type: AlertType.warning,
        buttons: [
          DialogButton(
            onPressed: () async {
              showProsses(context);
              var response = await http.post(
                  "https://shifon.ir/tmp/deleteproduct.php",
                  body: {'product_id': id, 'product_image': image});
              if (response.statusCode == 200) {
                datadeleted = true;
                notifyListeners();
                Navigator.pushNamed(context, '/manageproducts');
              }
            },
            child: Text(
              "?????? ??????????",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.redAccent,
            child: Text(
              "???????????? ?????? ",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

////// upload picture to server //////
  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 700);
      var compressImg = File("$path/product_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));
      productImageFile = compressImg;

      notifyListeners();
    } else {
      productImageFile = null;

      notifyListeners();
    }
  }

  ////// upload picture From Camera to server //////
  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 700);
      var compressImg = File("$path/product_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));
      productImageFile = compressImg;

      notifyListeners();
    } else {
      productImageFile = null;

      notifyListeners();
    }
  }
}
