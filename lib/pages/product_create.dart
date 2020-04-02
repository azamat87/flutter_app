
import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {

  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductCreatePageState();
  }
}

class _ProductCreatePageState extends State<ProductCreatePage> {

  String titleValue;
  String descriptionValue;
  double priceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Product Title'
            ),
            onChanged: (String value) {
              titleValue = value;
          },),
          TextField(
            decoration: InputDecoration(
                labelText: 'Product Description'
            ),
            maxLines: 4,
            onChanged: (String value) {
              descriptionValue = value;
          },),
          TextField(
            decoration: InputDecoration(
                labelText: 'Product Price'
            ),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              priceValue = double.parse(value);
          },),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('Save'),
              onPressed: () {
              final Map<String, dynamic> product = {
                'title' : titleValue,
                'description': descriptionValue,
                'price': priceValue,
                'image': 'images/food.jpg'
              };
              widget.addProduct(product);
              Navigator.pushReplacementNamed(context, '/');

          })
        ],
      ),
    );
  }
}
