
import 'dart:convert';

import 'package:flutterapp/constants.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/models/user.dart';
import 'package:http/http.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;

  void addProduct(String title, String description, double price, String image) {

    final Map<String, dynamic> productData = {
      TITLE: title,
      DESCRIPTION: description,
      IMAGE: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAQ8hFzWNhvpt3M0BCsmoKG1YvvPiLcBlkZ5cU7Y9tTizqXj4&s',
      PRICE: price
    };
    
    post('https://my-product-app-85b92.firebaseio.com/products.json', body: json.encode(productData));


    final Product newProduct = Product(
      id: ,
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);

    _products.add(newProduct);
    notifyListeners();
  }

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

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void deleteProduct() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void updateProduct(String title, String description, double price, String image) {
    final Product updateProduct = Product(title: title, description: description,
        price: price, image: image, userEmail: selectedProduct.userEmail, userId: selectedProduct.userId);

    _products[selectedProductIndex] = updateProduct;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
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

  void selectProduct(int index) {
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}


class UserModel extends ConnectedProductsModel {

  void login(String email, String password) {
    _authenticatedUser = User(id: "1", email: email, password: password);
  }

}