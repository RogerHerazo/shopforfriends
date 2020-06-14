import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/services/authentication.dart';

class AppProvider extends ChangeNotifier {

  BaseAuth auth;
  VoidCallback logoutCallback;
  String userId = "";
  User user;
  bool shopcartLocked = false;
  String friend = "";
  
}