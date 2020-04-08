import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/pages/product_edit.dart';
import 'package:flutterapp/scoped_model/products.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {

  Widget _buildEditButton(BuildContext context, int index, ProductModel model) {
      return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectProduct(index);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductEditPage();
          }));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductModel>(builder: (BuildContext context, Widget child, ProductModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            onDismissed: (DismissDirection dismiss) {
              if(dismiss == DismissDirection.endToStart) {
                model.selectProduct(index);
                model.deleteProduct();
              }
            },
            key: Key(model.products[index].title),
            background: Container(color: Colors.red,),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage: AssetImage(model.products[index].image,
                      )),
                  title: Text(model.products[index].title),
                  subtitle: Text('\$${model.products[index].price.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider()
              ],
            ),
          );
        },
        itemCount: model.products.length,
      );
    },
    );
  }
}
