import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/Pages/end.dart';
import 'package:shopforfriends/services/provider.dart';

enum LoadStatus {
  NOT_DETERMINED,
  VIEW_LOADED,
}

class Checkout extends StatefulWidget { 
  const Checkout({
    Key key, 
    @required this.shopcart,
    @required this.appProvider
  }) : super(key: key);

  final List<Product> shopcart;
  final AppProvider appProvider;

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  LoadStatus loadStatus = LoadStatus.VIEW_LOADED;
  List<Product> friendShopcart = new List<Product>();
  User friend;

  initState() {
    super.initState();
    if (widget.appProvider.friend != '') {
      _loadFriendShopcart();
    }
  }
  
  _createPayment() async {
    setState(() {
      loadStatus = LoadStatus.NOT_DETERMINED;
    });

    // var db= Firestore.instance();
    // var batch = db.batch();
    // batch.setData(
    //   db.collection(’users’).document(’id’),
    // //And the data to add in it.
    // {'status': 'Approved'}
    // );

    var json = {};
    for (var product in widget.shopcart) {
      json['${DateTime.now()}'] = product.toJson();
    }

    // await Firestore.instance.collection('users')
    //   .document(widget.userId)
    //   .setData({
    //       'payments': { json }
    //     }, 
    //     merge: true
    //   );

    await Firestore.instance.collection('users')
      .document(widget.appProvider.userId)
      .updateData({
          'shopcart': FieldValue.delete(),
          'friend_shopcart': FieldValue.delete()
        });

    widget.shopcart.clear();
    friendShopcart.clear();
    widget.appProvider.friend = "";

    setState(() {
      loadStatus = LoadStatus.VIEW_LOADED;
    });
  }

  _loadFriendShopcart() async {
    setState(() {
      loadStatus = LoadStatus.NOT_DETERMINED;
    });

    await Firestore.instance
    .collection('users')
    .document(widget.appProvider.friend)
    .get()
    .then((DocumentSnapshot ds) {
      log('loading user info!');
      setState(() {
        friend = new User(name: ds.data['email'], email: ds.data['email'], uid: widget.appProvider.friend);
      });
      if (ds.data['shopcart'] != null) {
        log('loading shopcart info! + ${ds.data['shopcart'].length}');
        setState(() {
          ds.data['shopcart'].forEach((k,v) {
            friendShopcart.add(
              new Product(
                index: v['index'],
                price: v['price'],
                name: v['name'],
                category: v['category'],
                amount: v['quantity']
              )
            );
          });
        });
      }
    });

    setState(() {
      loadStatus = LoadStatus.VIEW_LOADED;
    });
  }

  String _getTotal() {
    double total = 0;
    for (var product in widget.shopcart) {
      total = total + (product.amount.toInt() * product.price.toDouble());
    }
    if (widget.appProvider.friend != '') {
      for (var product in friendShopcart) {
        total = total + (product.amount.toInt() * product.price.toDouble());
      }
    }
    return total.toString();
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (_) => page), (route) => false);
  }

  Widget _buildUI(List<Product> shopcart){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Expanded(
              child: Container(
                child: Card(
                  
                  elevation : 10 , 
                  
                  margin: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget> [
                      Text("Shopping List", style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Colors.blue
      )),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: widget.shopcart.length,
                          itemBuilder: (context,index){
                          return Card(
                            elevation : 5 ,
                            margin: const EdgeInsets.all(15.0),
                                child: 
                                Text(
                                  shopcart[index].name+
                                  "                                  \X "+
                                  shopcart[index].amount.toString() +
                                  "\nPrice: \$"+
                                  shopcart[index].price.toString()
                                  
                                 , style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                  )),
                              
                            );
                        })
                      ),
                      Visibility(
                        visible: widget.appProvider.friend != '',
                        child: Expanded(
                        child: Container(
                          child: Card(
                            child: Column(
                              children: <Widget> [
                                Text("My Friend Shop List", style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue
                                )),
                                widget.appProvider.friend == '' ? Text('null') : Text('Username: ${friend.email}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color : Colors.red
                    )),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: false,
                                    itemCount: friendShopcart.length,
                                    itemBuilder: (context,index){
                                    return Card(
                                      elevation : 5 ,
                                      margin: const EdgeInsets.all(15.0),
                                        child: Center(
                                          child: widget.appProvider.friend == '' ? Text('null') : Text(
                                              friendShopcart[index].name+
                                              "                                  \X "+
                                              friendShopcart[index].amount.toString() +
                                              "\nPrice: \$"+
                                              friendShopcart[index].price.toString(), style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                            )
                                          )
                                        )
                                      );
                                    })
                                  )
                                ]
                              )
                            )
                          )
                        )
                      ),
                    ]
                  )
                )
              )
            ),
            Text("\$"+"${_getTotal()}", style: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold
      )),
            Container(
              child: RaisedButton(
              onPressed: () async {
                await _createPayment();

                _pushPage(context, End(
                  appProvider: widget.appProvider
                ));
              },
              child: Text('Checkout'),
              ),
            )
          ],
        ),
      );
  }
  
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget loadStatusWidget(BuildContext context) {
    switch (loadStatus) {
      case LoadStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case LoadStatus.VIEW_LOADED:
        return _buildUI(widget.shopcart)  ;
        break;
      default:
        return buildWaitingScreen();
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: loadStatusWidget(context)
    );
  }
}