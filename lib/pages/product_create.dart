
import 'dart:math';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Product Title'
      ),
      validator: (String value) {
        if(value.isEmpty) {
          return 'Title is required';
        }
      },
      onSaved: (String value) {
        setState(() {
          titleValue = value;
        });
      },);
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Product Description'
      ),
      maxLines: 4,
      onSaved: (String value) {
        setState(() {
          descriptionValue = value;
        });
      },);
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Product Price'
      ),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        setState(() {
          priceValue = double.parse(value);
        });
      },);
  }

  void _submitForm(){
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: <Widget>[
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildPriceTextField(),
            SizedBox(height: 10.0),
            RaisedButton(
              textColor: Colors.white,
              child: Text('Save'),
                onPressed: _submitForm
            )
          ],
        ),
      ),
    );
  }
}
