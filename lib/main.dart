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

  List<Map<String, dynamic>> _products = [];

  void _addProduct(Map<String, dynamic> product) {
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

  void _updateProduct(int index, Map<String, dynamic> product) {
    setState(() {
      _products[index] = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowMaterialGrid: true,
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple),
//      home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) => ProductAdminPage(_addProduct, _updateProduct, _deleteProduct, _products),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        print(pathElements);
        if(pathElements[0] != '') {
          return null;
        }

        if(pathElements[1] == 'product'){
          final int index = int.parse(pathElements[2]);
          print(_products);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(_products[index]['title'],
                _products[index]['image'], _products[index]['price']),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) => ProductsPage(_products)
        );
      },
    );
  }
}
