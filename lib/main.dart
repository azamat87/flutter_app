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

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> {

  List<Map<String, String>> _products = [];

  void _addProduct(Map<String, String> product) {
    setState(() {
      _products.add(product);
    });
    print(_products);
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

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
        '/': (BuildContext context) => ProductsPage(_products, _addProduct, _deleteProduct),
        '/admin': (BuildContext context) => ProductAdminPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        print(pathElements);
        if(pathElements[0] != ''){
          return null;
        }

        if(pathElements[1] == 'product'){
          final int index = int.parse(pathElements[2]);
          print(_products);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(_products[index]['title'],
                _products[index]['image']),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) =>
            ProductsPage(_products, _addProduct, _deleteProduct)
        );
      },
    );
  }
}
