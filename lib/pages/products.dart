import 'package:flutter/material.dart';
import 'package:flutterapp/scoped_model/main.dart';
import 'package:flutterapp/widgets/products/products.dart';
import 'package:flutterapp/widgets/ui_elements/adaptive_progress.dart';
import 'package:flutterapp/widgets/ui_elements/logout_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

import '../product_manager.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }

}

class _ProductsPageState extends State<ProductsPage> {

  @override
  initState(){
    widget.model.fetchProducts();
    super.initState();

  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: true,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTitle()
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(builder: (BuildContext builder, Widget child, MainModel model){
      Widget content = Center(child: Text('No products foun!'));
      if(model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: AdaptiveProgress());
      }
      return RefreshIndicator(onRefresh: model.fetchProducts, child: content);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(builder:
              (BuildContext context, Widget child, MainModel model) {
            return IconButton(
              icon: Icon(model.displayFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                model.toggleDisplayMode();
              },
            );
          })
        ],
      ),
      body: _buildProductsList(),
    );
  }
}
