import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/constants.dart';
import 'package:flutterapp/models/product.dart';
import 'package:flutterapp/scoped_model/main.dart';
import 'package:flutterapp/widgets/form_inputs/image.dart';
import 'package:flutterapp/widgets/helpers/ensure_visible.dart';
import 'package:flutterapp/widgets/ui_elements/adaptive_progress.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    TITLE: null,
    DESCRIPTION: null,
    PRICE: null,
    IMAGE: null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  final _descTextController = TextEditingController();

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        initialValue: product == null ? '' : product.title,
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long';
          }
        },
        onSaved: (String value) {
          _formData[TITLE] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    if (product == null && _descTextController.text.trim() == '') {
      _descTextController.text = '';
    } else if (product != null && _descTextController.text.trim() == '') {
      _descTextController.text = product.description;
    }

    return EnsureVisibleWhenFocused(
      focusNode: _descFocusNode,
      child: TextFormField(
        focusNode: _descFocusNode,
        decoration: InputDecoration(labelText: 'Product Description'),
//        initialValue: product == null ? '' : product.description,
        controller: _descTextController,
        maxLines: 4,
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long';
          }
        },
        onSaved: (String value) {
          _formData[DESCRIPTION] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        decoration: InputDecoration(labelText: 'Product Price'),
        initialValue: product == null ? '' : product.price.toString(),
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Price is required and should be number.';
          }
        },
        onSaved: (String value) {
          _formData[PRICE] = double.parse(value);
        },
      ),
    );
  }

  void _setImage(File image) {
    _formData[IMAGE] = image;
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData[IMAGE] == null && selectedProductIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(_formData[TITLE], _descTextController.text, _formData[PRICE],
              _formData[IMAGE])
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Somthing went wrong'),
                  content: Text('Please try again'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"))
                  ],
                );
              });
        }
      });
    } else {
      updateProduct(_formData[TITLE], _descTextController.text,
              _formData[PRICE], _formData[IMAGE])
          .then((_) => Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null)));
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      return model.isLoading
          ? Center(
              child: AdaptiveProgress(),
            )
          : RaisedButton(
              textColor: Colors.white,
              child: Text('Save'),
              onPressed: () => _submitForm(
                  model.addProduct,
                  model.updateProduct,
                  model.selectProduct,
                  model.selectedProductIndex),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Product product) {
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
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 10.0),
              ImageInput(_setImage, product),
              SizedBox(height: 10.0),
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget widget, MainModel model) {
      final Widget pageContent =
          _buildPageContent(context, model.selectedProduct);

      return model.selectedProductIndex == -1
          ? pageContent
          : Scaffold(
              appBar: AppBar(
                title: Text('Edit Product'),
              ),
              body: pageContent,
            );
    });
  }
}
