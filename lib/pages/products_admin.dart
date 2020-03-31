
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/product_create.dart';
import 'package:flutterapp/pages/product_list.dart';
import 'package:flutterapp/pages/products.dart';

import '../product_manager.dart';

class ProductAdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: true,
                title: Text('Choose'),
              ),
              ListTile(
                title: Text('EasyList'),
                onTap: (){
                  Navigator.pushReplacementNamed(context, '/');
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              )
            ],
          ),
        ),
        body: TabBarView(
            children: <Widget> [
              ProductCreatePage(),
              ProductListPage()
            ]
        ),
      ),
    );
  }
}