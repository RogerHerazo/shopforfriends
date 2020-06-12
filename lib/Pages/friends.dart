import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/Pages/end.dart';
import 'package:shopforfriends/Pages/friend_detail.dart';

enum LoadStatus {
  NOT_DETERMINED,
  VIEW_LOADED,
}

class Friends extends StatefulWidget { 
  const Friends({Key key, this.userId}) : super(key: key);

  final String userId;

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  LoadStatus loadStatus = LoadStatus.VIEW_LOADED;
  List<User> users = new List<User>();

  initState() {
    super.initState();
    _getUsers();
  }

  _getUsers() async {
    setState(() {
      loadStatus = LoadStatus.NOT_DETERMINED;
    });

    await Firestore.instance.collection('users')
      .getDocuments()
      .then((QuerySnapshot snapshot) {
        setState(() {
          snapshot.documents.forEach((u) {
            print('${u.data}}');
            if (u.documentID != widget.userId) {
              users.add(new User(uid: u.documentID, email: u['email']));
            }
          });
        });
      });

    setState(() {
      loadStatus = LoadStatus.VIEW_LOADED;
    });
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
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
                      Text("My Friends List"),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: users.length,
                          itemBuilder: (context,index){
                          return Card(
                            margin: const EdgeInsets.all(10.0),
                              child: Center(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    _pushPage(context, FriendDetail(userId: users[index].uid));
                                  },
                                  child: Text(users[index].email)
                                )
                              ),
                            );
                        })
                      )
                    ]
                  )
                )
              )
            ),
          ],
        ),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: ChangeNotifierProvider<SingleModel>(
        create: (context) => SingleModel(chkstate : "Pay"),
        child: _buildUI()     
      ), 
    );
  }
}

class SingleModel extends ChangeNotifier {
  String chkstate;
  SingleModel({this.chkstate});

  void changeValue(String chk) {
    chkstate = chk;
    notifyListeners(); 
  }
}
