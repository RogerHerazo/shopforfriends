import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopforfriends/services/authentication.dart';
import 'package:shopforfriends/Pages/root_page.dart';
import 'package:shopforfriends/services/provider.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  AppProvider appProvider = AppProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppProvider>(
      //      <--- ChangeNotifierProvider
      create: (context) => appProvider,
      child: MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(appProvider: appProvider))
    );
  }
}
