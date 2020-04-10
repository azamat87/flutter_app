import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/scoped_model/main.dart';
import 'package:flutterapp/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';


class ProductPage extends StatelessWidget {

  final int productIndex;

  ProductPage(this.productIndex);

  _showWarningDialog(BuildContext buildContext){
    showDialog(context: buildContext, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('This action cannot be undone!'),
        actions: <Widget>[
          FlatButton(child: Text('DISCARD'), onPressed: () {
            Navigator.pop(context);
          }),
          FlatButton(child: Text('CONTINUE'), onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context, true);
          })
        ],
      );
    });
  }

  Widget _buildAddressPriceRow(double price) {
    return Row (
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Union Square',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
        Product product = model.allProducts[productIndex];

        return  Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(product.image),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(product.title)),
              _buildAddressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('DELETE'),
                  onPressed: () => _showWarningDialog(context),
                ),
              )
            ],
          ),
        );
      })
    );
  }
}