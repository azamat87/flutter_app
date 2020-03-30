import 'package:flutter/material.dart';
import 'package:flutterapp/pages/auth.dart';
import 'package:flutterapp/pages/product.dart';
import 'package:flutterapp/pages/products.dart';
import 'package:flutterapp/pages/products_admin.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple),
//      home: AuthPage(),
      routes: {
        '/': (BuildContext context) => ProductsPage(),
        '/admin': (BuildContext context) => ProductAdminPage()
      },
    );
  }
}
