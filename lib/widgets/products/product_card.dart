import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/scoped_model/main.dart';
import 'package:flutterapp/widgets/products/address_tag.dart';
import 'package:flutterapp/widgets/products/price_tag.dart';
import 'package:flutterapp/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(width: 8.0),
          PriceTag(product.price.toString()),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme
                    .of(context)
                    .accentColor,
                onPressed: () {
                  model.selectProduct(model.allProducts[productIndex].id);
                  Navigator.pushNamed<bool>(
                      context, '/product/' + model.allProducts[productIndex].id)
                  .then((_) => model.selectProduct(null));
                }
              ),
              IconButton(
                icon: Icon(model.allProducts[productIndex].isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectProduct(model.allProducts[productIndex].id);
                  model.toggleProductFavoriteStatus();
                },
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300,
            fit: BoxFit.cover,
            placeholder: AssetImage('images/food.png'),
          ),
          _buildTitlePriceRow(),
          AddressTag('Union Square'),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
