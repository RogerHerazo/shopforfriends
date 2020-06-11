// import 'package:flutter/material.dart';
// import 'package:shopforfriends/Pages/login.dart';
// import 'Pages/home.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//               title: 'Login Navigation',
//               theme: ThemeData(
//                 primarySwatch: Colors.deepPurple,
//                 accentColor: Colors.orange,
//                 cursorColor: Colors.orange,
//                 textTheme: TextTheme(
//                   display2: TextStyle(
//                     fontFamily: 'OpenSans',
//                     fontSize: 45.0,
//                     color: Colors.orange,
//                   ),
//                   button: TextStyle(
//                     fontFamily: 'OpenSans',
//                   ),
//                   subhead: TextStyle(fontFamily: 'NotoSans'),
//                   body1: TextStyle(fontFamily: 'NotoSans'),
//                 ),
//               ),
//               home: Login(),
//               routes: <String, WidgetBuilder> {
//               '/home': (BuildContext context) => Home(),
//               },
//             );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shopforfriends/services/authentication.dart';
import 'package:shopforfriends/Pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
