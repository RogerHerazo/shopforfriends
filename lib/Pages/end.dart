import 'package:flutter/material.dart';
import 'package:shopforfriends/Pages/home.dart';
import 'package:shopforfriends/Pages/login.dart';
import 'package:shopforfriends/services/authentication.dart';
import 'package:shopforfriends/services/provider.dart';

class End extends StatefulWidget {
  End({
    Key key, 
    @required this.appProvider
  }) : super(key: key);

  final AppProvider appProvider;

  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Successfull Payment"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
                Card(
                  child: Column(
                    children: <Widget> [
                      Text("Thanks For Your Buy")
                    ]
                  )
                ),
                // RaisedButton(
                // onPressed: () {
                //     print("Chekout...");
                //     _pushPage(context, Login(appProvider: wdiget.appProvider));
                //   },
                //   child: Text("LogOut"),
                // ),
                RaisedButton(
                onPressed: () {
                    print("Chekout...");
                    _pushPage(context, Home(
                        appProvider: widget.appProvider
                      )
                    );
                  },
                  child: Text("Shop Again"),
                ),
          ],
        ),
      )
    );
  }
}

void _pushPage(BuildContext context, Widget page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (_) => page), (route) => false);
}