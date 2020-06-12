
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/Pages/checkout.dart';
import 'package:shopforfriends/services/authentication.dart';

enum AuthStatus {
  NOT_DETERMINED,
  VIEW_LOADED,
}

class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  var products = new List<Product>();
  List<int> cant;
  List<Product> productlist = [];
  List<Product> friendproductlist = [];
  User _user;

  initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    await _getProducts();

    await Firestore.instance
      .collection('users')
      .document(widget.userId)
      .get()
      .then((DocumentSnapshot ds) {
        log('loading user info!');
        setState(() {
          _user = new User(name: ds.data['email'], email: ds.data['email'], uid: widget.userId);
        });
        if (ds.data['shopcart'] != null) {
          log('loading shopcart info! + ${ds.data['shopcart'].length}');
          setState(() {
            ds.data['shopcart'].forEach((k,v) {
              // log('loading shopcart info! + $k');
              cant[int.parse(k)] = v['quantity'];
              productlist.add(products[int.parse(k)]);
            });
          });
          // log('loading user info!');
        }
        // log('loading user info!');
      });

    setState(() {
      authStatus = AuthStatus.VIEW_LOADED;
    });
  }

  _getProducts() async {
    final http.Response response = await http.get(
      'https://frutiland.herokuapp.com/search'
    );
    print('${response.body}');
    print('${response.statusCode}');
    setState(() {
      Iterable list = json.decode(response.body);
      products = list.map((model) => Product.fromJson(model)).toList();
      cant = new List.filled(products.length, 0);
    });
  }

  _updateShopcart(int index, int quantity) async {
    if (quantity == 0) {
      await Firestore.instance.collection('users')
        .document(widget.userId)
        .updateData({
          'shopcart.$index': FieldValue.delete()
        });
    } else {
      await Firestore.instance.collection('users')
        .document(widget.userId)
        .setData({
            'shopcart': {
              '$index': {
                'price': products[index].price,
                'name': products[index].name,
                'category': products[index].category,
                'quantity': quantity,
              }
            }
          }, 
          merge: true
        );
    }
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget home() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Username: ${_user?.email}"),
                ]
              )
            ),
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                    print("Chekout...");
                    _pushPage(context, Checkout(productlist: productlist,));
                  },
                  child: Icon(Icons.shopping_cart),
                  ),
              RaisedButton(
                onPressed: () {
                  print("View Friends Shopping List");
                },
              child: Text("View Friends"),
              ),
            ]),
            Divider(
              color: Colors.black,
            ),
            Expanded(
              child:ListView.builder(
              shrinkWrap: false,
              itemCount: products.length,
              itemBuilder: (context,index){
              return Card(
                margin: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                      Text(products[index].name+"\nPrecio: \$"+products[index].price.toString()),
                      Container(
                        // padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(
                          children: <Widget>[
                          Container(
                        width: 50,
                        child: RaisedButton(
                          child: Icon(Icons.add),
                          onPressed: () => {
                            productlist.add(products[index]),
                            setState(() {
                              cant[index] += 1;
                            }),
                            _updateShopcart(index, cant[index]),
                            print('Added product ' + productlist.length.toString()),
                            for (var p in productlist) {
                              print(p.toString())  
                            }
                          })
                      ),
                          Container(
                            width: 50,
                            child: RaisedButton(
                              child: Icon(Icons.remove),
                              onPressed: () => {
                                if (cant[index] > 0){
                                  productlist.remove(products[index]),
                                  setState(() {
                                    cant[index] -= 1;
                                  }),
                                  _updateShopcart(index, cant[index]),
                                  print('Removed product ' + productlist.length.toString()),
                                  for (var p in productlist) {
                                    print(p.toString())  
                                  },
                                },
                              })
                          ),
                        ],)
                      ),
                      Text("Cant: " + ((cant[index] >= 0)? cant[index].toString(): "0"))
                    ]
                  )
                );
            })                         
            )
          ]
        ),
      )
    );
  }

  void _pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.VIEW_LOADED:
        return home();
        break;
      default:
        return buildWaitingScreen();
    } 
  }
}