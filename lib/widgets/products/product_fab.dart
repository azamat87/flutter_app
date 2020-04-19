
import 'package:flutter/material.dart';

class ProductFab extends StatefulWidget {
  @override
  _ProductFabState createState() => _ProductFabState();
}

class _ProductFabState extends State<ProductFab> {
//  Text(product.userEmail!=null ? product.userEmail: 'userEmail'),
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            heroTag: 'contcat',
            mini: true,
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {

          },
            child: Icon(Icons.mail, color: Theme.of(context).primaryColor),
          ),
        ),

        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            heroTag: 'favorite',
            mini: true,
            backgroundColor: Theme.of(context).cardColor,
            onPressed: () {

          },
            child: Icon(Icons.favorite, color: Colors.red,),
          ),
        ),

        Container(
          child: FloatingActionButton(
            heroTag: 'options',
            onPressed: () {

          },
            child: Icon(Icons.more_vert),
          ),
        ),

      ],
    );
  }
}
