import 'package:flutter/material.dart';

class AdminMenuModel {
  String title;
  IconData icon;
  String link ;

  AdminMenuModel({this.title, this.icon , this.link});
}

List<AdminMenuModel> adminmenuitem = [
  AdminMenuModel(title: 'مدیریت دسته بندی', icon: Icons.category , link: '/managecategories'),
  AdminMenuModel(title: 'مدیریت محصول ', icon: Icons.shopping_basket , link: '/manageproducts'),
  AdminMenuModel(title: 'مدیریت کاربران ', icon: Icons.person , link: '/'),
  AdminMenuModel(title: 'تنظیمات ', icon: Icons.settings , link: '/scan'),


];