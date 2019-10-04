import 'dart:io';
import 'dart:math' as Math;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:path/path.dart';

import '../models/categoriesmodel.dart';
import '../models/productmodel.dart';

class MainModel extends Model {
  List<CategoriesModel> categoriData = [];
  List<ProductModel> selectedProductData = [];
  List<ProductModel> productData = [];
  Map<int, ProductModel> productcart = {};
  Map<String, String> categoriList = {};
  String barcode = '';

  bool isLoadingCategories = true;
  bool isLoadingProductData = true;
  bool isLoadingAllProduct = true;
  bool isLoadingSelectedProduct = true;

  bool dataAdded = true;
  bool datadeleted = false;
  bool dataupdated = false;

  String currentSelectedCatID;
  File cateImageFile;

  Future successDialog({context, title, desc}) async {
    return Alert(
        context: context,
        title: title,
        type: AlertType.success,
        desc: desc,
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "+ محصول جدید",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.redAccent,
            child: Text(
              "لیست محصولات",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          )
        ]).show();
  }

//--Scan Barcode --//
  Future<void> scanBarcode() async {
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "بی خیال", true, ScanMode.BARCODE);
    } on PlatformException {
      barcode = 'بارکد خوانده نشد';
    }
  }

//---fetch All Categories From server---//
  Future fetchCategories() async {
    categoriData.clear();
    isLoadingCategories = true;
    notifyListeners();
    final response = await http.get('https://shifon.ir/tmp/getcategories.php');
    categoriData = (json.decode(response.body) as List)
        .map((i) => CategoriesModel.catjson(i))
        .toList();
    isLoadingCategories = false;
    notifyListeners();
    return categoriData;
  }

//---fetch All Products From server---//
  Future fetchProducts() async {
    productData.clear();
    isLoadingAllProduct = true;
    notifyListeners();
    final response = await http.get('https://shifon.ir/tmp/getproducts.php');
    List<dynamic> data = json.decode(response.body);
    ProductModel products = ProductModel();
    data.forEach((dynamic protdata) {
      products = ProductModel(
          product_id: protdata['product_id'],
          product_name: protdata['product_name'],
          product_category: protdata['product_category'],
          product_des: protdata['product_des'],
          product_color: protdata['product_color'],
          product_size: protdata['product_size'],
          product_barcode: protdata['product_barcode'],
          product_image: protdata['product_image'],
          product_count: protdata['product_count'],
          product_price_buy: protdata['product_price_buy'],
          product_price_sell: protdata['product_price_sell']);
      productData.add(products);
      notifyListeners();
    });

    isLoadingAllProduct = false;
    notifyListeners();
    return productData;
  }

  //////////////////
  Future fetchSelectedProducts(String categoryid) async {
    print("Run Fetch for $categoryid");
    selectedProductData.clear();
    isLoadingSelectedProduct = true;
    notifyListeners();
    final response = await http.get('https://shifon.ir/tmp/getproducts.php');
    List<dynamic> data = json.decode(response.body);
    ProductModel products = ProductModel();
    data.forEach((dynamic protdata) {
      products = ProductModel(
          product_id: protdata['product_id'],
          product_name: protdata['product_name'],
          product_category: protdata['product_category'],
          product_des: protdata['product_des'],
          product_color: protdata['product_color'],
          product_size: protdata['product_size'],
          product_barcode: protdata['product_barcode'],
          product_image: protdata['product_image'],
          product_count: protdata['product_count'],
          product_price_buy: protdata['product_price_buy'],
          product_price_sell: protdata['product_price_sell']);

      if (products.product_category == categoryid) {
        selectedProductData.add(products);
      }
      notifyListeners();
    });
    currentSelectedCatID = categoryid;
    isLoadingSelectedProduct = false;
    notifyListeners();
    return productData;
  }

///////////////////////
  Future addCategories(
      CategoriesModel newCategorie, File newCategoriImage) async {
    dataAdded = false;
    // if Categori has Icon File
    if (newCategoriImage != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(newCategoriImage.openRead()));
      var length = await newCategoriImage.length();
      var url = Uri.parse("https:/shifon.ir/tmp/addcategory.php");
      var request = http.MultipartRequest("POST", url);
      var multipartFile = http.MultipartFile("categorie_icon", stream, length,
          filename: basename(newCategoriImage.path));
      request.files.add(multipartFile);
      request.fields['categoie_name'] = newCategorie.categorie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_state'] = newCategorie.categorie_state;
      await request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Upload Data:${resopnse.statusCode} ");
        }
      });
    }
    // if categori has not Icon file . send empty image to data base
    else {
      var url = Uri.parse("https://shifon.ir/tmp/addcategory.php");
      var request = http.MultipartRequest("POST", url);
      request.fields['categoie_name'] = newCategorie.categorie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_icon'] = "noimage.png";
      request.fields['categorie_state'] = newCategorie.categorie_state;
      await request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Upload Data Ok");
          dataAdded = true;
          notifyListeners();
        } else {
          print("Error to Upload Data:${resopnse.statusCode} ");
        }
      });
    }
    return dataAdded;
  }

//// Add New Product ////

  Future addNewProduct(ProductModel newProduct) async {
    print(newProduct.product_name);
    print(newProduct.product_price_buy);
    print(newProduct.product_price_sell);
    print(newProduct.product_image);
  }

  Future updateCategories(
      CategoriesModel newCategorie, File newCategoriImage) async {
    print(newCategorie.categorie_id);
    print(newCategorie.categorie_name);
    print(newCategorie.categorie_des);
    print(newCategorie.categorie_state);
    print(newCategorie.categorie_icon);
    print(newCategoriImage);
    dataupdated = false;
    if (newCategoriImage != null) {
      var stream =
          http.ByteStream(DelegatingStream.typed(newCategoriImage.openRead()));
      var length = await newCategoriImage.length();
      var url = Uri.parse("https://shifon.ir/tmp/editcategory.php");
      var request = http.MultipartRequest("POST", url);
      var multipartFile = http.MultipartFile("categorie_icon", stream, length,
          filename: basename(newCategoriImage.path));
      request.files.add(multipartFile);
      request.fields['categorie_id'] = newCategorie.categorie_id;
      request.fields['categoie_name'] = newCategorie.categorie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_state'] = newCategorie.categorie_state;

      await request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Edit Data Ok");
          dataupdated = true;
          notifyListeners();
        } else {
          print("Error to Edit Data:${resopnse.statusCode} ");
        }
      });
    } else {
      ///
      var url = Uri.parse("https://shifon.ir/tmp/editcategory.php");
      var request = http.MultipartRequest("POST", url);
      request.fields['categorie_id'] = newCategorie.categorie_id;
      request.fields['categoie_name'] = newCategorie.categorie_name;
      request.fields['categorie_des'] = newCategorie.categorie_des;
      request.fields['categorie_icon'] = newCategorie.categorie_icon;
      request.fields['categorie_state'] = newCategorie.categorie_state;
      await request.send().then((resopnse) {
        if (resopnse.statusCode == 200) {
          print("Edit Data Ok whitout change picture");
          dataupdated = true;
          notifyListeners();
        } else {
          print("Error to Edit Data:${resopnse.statusCode} ");
        }
      });
    }
    return dataupdated;
  }

// delete Categori with Picture file
  Future deleteCategories(String id, String icon) async {
    datadeleted = false;

    var response = await http.post("https://shifon.ir/tmp/deletecategory.php",
        body: {'categorie_id': id, 'categorie_icon': icon});
    if (response.statusCode == 200) {
      datadeleted = true;
      notifyListeners();
      print(icon);
    }
    return datadeleted;
  }

////// upload picture to server //////
  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Math.Random().nextInt(10000);
    if (imageFile != null) {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 500);
      var compressImg = File("$path/categorie_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 95));
      cateImageFile = compressImg;

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
      Img.Image smallerImg = Img.copyResize(image, width: 500);
      var compressImg = File("$path/categorie_image_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 95));
      cateImageFile = compressImg;

      notifyListeners();
    }
  }
}
