import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped/mainscoped.dart';
import '../models/adminmenumodel.dart';
import './adminmenuitems.dart';
import '../theme/menutheme.dart';

class Menu extends StatefulWidget {
 _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  double maxwith = 250;
  double minwith = 0;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
              width: maxwith,
              color: menuBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40, right: 18),
                    child: Text(
                      "کالکشن محصولات",
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 25),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Expanded(
                    child: model.categoriList.length == 0
                        ? Center(
                            child: Text('هیچ کالکشنی نیست !'),
                          )
                        : ListView.builder(
                            itemCount: model.categoriList.length,
                            itemBuilder: (context, index) {
                              return null;
                             
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      'منوی مدیریت',
                      style:
                          TextStyle(fontSize: 25, color: Colors.grey.shade800),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: adminmenuitem.length,
                      itemBuilder: (context, index) {
                        return AdminMenuItems(
                          icon: adminmenuitem[index].icon,
                          menutitle: adminmenuitem[index].title,
                          link: adminmenuitem[index].link,
                        );
                      },
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
