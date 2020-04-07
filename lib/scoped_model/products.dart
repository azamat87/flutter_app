import 'package:flutterapp/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductModel extends Model {

  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
  }

  void deleteProduct(int index) {
    _products.removeAt(index);
  }

  void updateProduct(int index, Product product) {
    _products[index] = product;
  }

}