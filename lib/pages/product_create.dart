
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
        if(value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long';
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
      validator: (String value) {
        if(value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long';
        }
      },
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
      validator: (String value) {
        if(value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be number.';
        }
      },
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
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
      ),
    );
  }
}
