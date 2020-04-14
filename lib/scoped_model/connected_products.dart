import 'dart:convert';

import 'package:flutterapp/constants.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/models/user.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;

}

class ProductModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return List.from(
          _products.where((Product product) => product.isFavorite).toList());
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Future<bool> addProduct(String title, String description, double price,
      String image) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      TITLE: title,
      DESCRIPTION: description,
      IMAGE: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAQ8hFzWNhvpt3M0BCsmoKG1YvvPiLcBlkZ5cU7Y9tTizqXj4&s',
      PRICE: price,
      USER_EMAIL: _authenticatedUser.email,
      USER_ID: _authenticatedUser.id
    };

    try {
      final Response response = await post(
          'https://my-product-app-85b92.firebaseio.com/products.json',
          body: json.encode(productData));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      _isLoading = false;
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);

      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch(e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
//        .catchError((error) {
//      _isLoading = false;
//      notifyListeners();
//      return false;
//    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return delete(
        'https://my-product-app-85b92.firebaseio.com/products/$deletedProductId.json')
        .then((Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> updateProduct(String title, String description, double price,
      String image) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      TITLE: title,
      DESCRIPTION: description,
      IMAGE: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAQ8hFzWNhvpt3M0BCsmoKG1YvvPiLcBlkZ5cU7Y9tTizqXj4&s',
      PRICE: price,
      USER_EMAIL: selectedProduct.userEmail,
      USER_ID: selectedProduct.userId
    };

    return put(
        'https://my-product-app-85b92.firebaseio.com/products/${selectedProduct
            .id}.json',
        body: json.encode(updateData))
        .then((Response response) {
      _isLoading = false;
      final Product updateProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      _products[selectedProductIndex] = updateProduct;
      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return get('https://my-product-app-85b92.firebaseio.com/products.json')
        .then<Null>((Response response) {
      final List<Product> fetchedProductLit = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            title: productData[TITLE],
            description: productData[DESCRIPTION],
            image: productData[IMAGE],
            price: productData[PRICE],
            userEmail: productData[USER_EMAIL],
            userId: productData[USER_ID]);
        fetchedProductLit.add(product);
      });
      _products = fetchedProductLit;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {

  final String _key = '';


  Future<Map<String, dynamic>> login(String email, String password) async {
//    _authenticatedUser = User(id: "1", email: email, password: password);
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final Response response = await post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_key',
        body: json.encode(authData), headers: {'Content-Type': 'application/jon'});

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Somthing went wrong';
    if(responseData.containsKey('idToken')) {
      hasError = false;
      message = "Success";
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND'){
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD'){
      message = 'Invalid password.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  Future<Map<String, dynamic>> singup(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final Response response = await post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_key',
        body: json.encode(authData), headers: {'Content-Type': 'application/jon'}
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Somthing went wrong';
    if(responseData.containsKey('idToken')) {
      hasError = false;
      message = "Success";
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS'){
      message = 'This email alredy exists.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
