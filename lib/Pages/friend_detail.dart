import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/services/provider.dart';

enum LoadStatus {
  NOT_DETERMINED,
  VIEW_LOADED,
}

class FriendDetail extends StatefulWidget { 
  const FriendDetail({Key key, @required this.appProvider, @required this.userId}) : super(key: key);

  final AppProvider appProvider;
  final String userId;

  @override
  _FriendDetailState createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  LoadStatus loadStatus = LoadStatus.NOT_DETERMINED;
  List<Product> shopcart = new List<Product>();
  User _user;

  initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    await Firestore.instance
      .collection('users')
      .document(widget.userId)
      .get()
      .then((DocumentSnapshot ds) {
        setState(() {
          _user = new User(name: ds.data['email'], email: ds.data['email'], uid: widget.appProvider.userId);
        });
        if (ds.data['shopcart'] != null) {
          setState(() {
            ds.data['shopcart'].forEach((k,v) {
              shopcart.add(
                new Product(
                  index: v['index'],
                  price: v['price'],
                  name: v['name'],
                  category: v['category'],
                  amount: v['quantity'],
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

  _updateShopcart() async {
    await Firestore.instance.collection('users')
      .document(widget.appProvider.userId)
      .setData({
          'friend_shopcart': '${widget.userId}'
        }, 
        merge: true
      );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (_) => page), (route) => false);
  }

  void _ackAlert(
      {BuildContext context,
      String title,
      String message,
      bool redirect}) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: Text('$message'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUI(){
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Expanded(
              child: Container(
                child: Card(
                  child: Column(
                    children: <Widget> [
                      Text("Username: ${_user?.email}"),
                      Divider(
                        color: Colors.black,
                      ),
                      Text("Active shopcart: "),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: shopcart.length,
                          itemBuilder: (context,index){
                          return Card(
                            margin: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  shopcart[index].name+
                                  "\nPrice: \$"+
                                  shopcart[index].price.toString()+
                                  "\nAmount: \$"+
                                  shopcart[index].amount.toString()
                                ),
                              )
                            );
                        })
                      )
                    ]
                  )
                )
              )
            ),
            Container(
              child: RaisedButton(
                onPressed: () {
                  if (widget.appProvider.shopcartLocked) {
                    _ackAlert(context: context, title: 'Error', message: 'You have closed your shopcart!');
                  } else {
                    _ackAlert(context: context, title: 'Operation successfull', message: 'Your friend\'s list was successfully added into yours!');
                    widget.appProvider.friend = widget.userId;
                    _updateShopcart();
                  }
                },
                child: Text('I want to pay it!'),
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
        return _buildUI()  ;
        break;
      default:
        return buildWaitingScreen();
    } 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Detail"),
      ),
      body: loadStatusWidget(context)       
    );
  }
}
