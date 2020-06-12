import 'package:flutter/material.dart';
import 'package:shopforfriends/Pages/home.dart';
import 'package:shopforfriends/services/provider.dart';

class Login extends StatelessWidget {
  Login({
    Key key, 
    @required this.appProvider
  }) : super(key: key);

  final AppProvider appProvider;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
            child: Text("Login"),
            onPressed: () => _pushPage(context, Home(appProvider: appProvider))),
          ],
        ),
      ),
    );
  }
}

void _pushPage(BuildContext context, Widget page){
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}