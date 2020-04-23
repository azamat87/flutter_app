import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android
        ? CircularProgressIndicator()
        : CupertinoActivityIndicator();
  }

}