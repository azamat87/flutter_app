import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/pages/product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;

  ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(products[index][TITLE]),
          background: Container(color: Colors.red,),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage(products[index][IMAGE],
                )),
                title: Text(products[index][TITLE]),
                subtitle: Text('\$${products[index][PRICE].toString()}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return ProductEditPage(
                        product: products[index],
                        updateProduct: updateProduct,
                        productIndex: index,
                      );
                    }));
                  },
                ),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
