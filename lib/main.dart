import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/pages/auth.dart';
import 'package:flutterapp/pages/product.dart';
import 'package:flutterapp/pages/products.dart';
import 'package:flutterapp/pages/products_admin.dart';
import 'package:flutterapp/scoped_model/main.dart';
import 'package:flutterapp/widgets/adaptive_theme.dart';
import 'package:flutterapp/widgets/helpers/custom_route.dart';
import 'package:scoped_model/scoped_model.dart';

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
  final MainModel _mainModel = MainModel();
  bool _isAuth = false;

  final _platformChannel = MethodChannel('product-app/battery');

  Future<Null> getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platformChannel.invokeMethod('getBateryLevel');
      batteryLevel = 'Level is $result %.';
    } catch(error) {
      batteryLevel = 'Error';
    }
    print(batteryLevel);
  }

  @override
  void initState() {
    _mainModel.autoAuthenticate();
    _mainModel.userSubject.listen((bool isAuth) {
      setState(() {
        _isAuth = isAuth;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: MaterialApp(
        title: 'EasyList',
        // debugShowMaterialGrid: true,
        theme: getAdaptiveThemeData(context),
//      home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              !_isAuth ? AuthPage() : ProductsPage(_mainModel),
          '/admin': (BuildContext context) =>
              !_isAuth ? AuthPage() : ProductAdminPage(_mainModel),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuth) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }

          final List<String> pathElements = settings.name.split('/');
          print(pathElements);
          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _mainModel.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return CustomRoute<bool>(
              builder: (BuildContext context) =>
                  !_isAuth ? AuthPage() : ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuth ? AuthPage() : ProductsPage(_mainModel));
        },
      ),
    );
  }
}
