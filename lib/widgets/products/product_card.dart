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

  ProductCard(this.product);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(child: TitleDefault(product.title)),
          Flexible(child: SizedBox(width: 8.0)),
          Flexible(child: PriceTag(product.price.toString())),
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
                  model.selectProduct(product.id);
                  Navigator.pushNamed<bool>(
                      context, '/product/' + product.id)
                  .then((_) => model.selectProduct(null));
                }
              ),
              IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectProduct(product.id);
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
          Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.image),
              height: 300,
              fit: BoxFit.cover,
              placeholder: AssetImage('images/food.png'),
            ),
          ),
          _buildTitlePriceRow(),
          SizedBox(height: 10.0,),
          AddressTag('Union Square'),
          _buildActionButtons(context)
        ],
      ),
    );
  }
}
