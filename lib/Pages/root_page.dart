import 'package:flutter/material.dart';
import 'package:shopforfriends/Pages/login_signup_page.dart';
import 'package:shopforfriends/services/authentication.dart';
import 'package:shopforfriends/services/provider.dart';

import 'home.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({@required this.appProvider});

  final AppProvider appProvider;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();
    widget.appProvider.auth = new Auth();
    widget.appProvider.logoutCallback = logoutCallback;
  
    widget.appProvider.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          widget.appProvider.userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.appProvider.auth.getCurrentUser().then((user) {
      setState(() {
        widget.appProvider.userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      widget.appProvider.userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.appProvider.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (widget.appProvider.userId.length > 0 && widget.appProvider.userId != null) {
          return new Home(
            appProvider: widget.appProvider
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
