import 'package:flutter/material.dart';
import 'package:flutterapp/pages/products.dart';
import 'package:flutterapp/pages/products_admin.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email;
  String _password;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: AssetImage('images/background.jpg'))),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Input E-Mail',
                        filled: true,
                        fillColor: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) {
                      _email = value;
                    },
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white),
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (String value) {
                      _password = value;
                    },
                  ),
                  SwitchListTile(
                    value: true,
                    onChanged: (bool value) {
                      setState(() {
                        _acceptTerms = value;
                      });
                    },
                    title: Text('Accept terms'),
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                      child: Text('LOGIN'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
