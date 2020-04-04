
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

  Widget _buildTitleTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Product Title'
      ),
      onChanged: (String value) {
        titleValue = value;
      },);
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Product Description'
      ),
      maxLines: 4,
      onChanged: (String value) {
        descriptionValue = value;
      },);
  }

  Widget _buildPriceTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Product Price'
      ),
      keyboardType: TextInputType.number,
      onChanged: (String value) {
        priceValue = double.parse(value);
      },);
  }

  void _submitForm(){
    final Map<String, dynamic> product = {
      'title' : titleValue,
      'description': descriptionValue,
      'price': priceValue,
      'image': 'images/food.jpg'
    };
    widget.addProduct(product);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          _buildTitleTextField(),
          _buildDescriptionTextField(),
          _buildPriceTextField(),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Theme.of(context).accentColor,
            textColor: Colors.white,
            child: Text('Save'),
              onPressed: _submitForm
          )
        ],
      ),
    );
  }
}
