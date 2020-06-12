import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/Pages/friend_detail.dart';
import 'package:shopforfriends/services/provider.dart';

enum LoadStatus {
  NOT_DETERMINED,
  VIEW_LOADED,
}

class Friends extends StatefulWidget { 
  const Friends({Key key, @required this.appProvider}) : super(key: key);

  final AppProvider appProvider;

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
            if (u.documentID != widget.appProvider.userId) {
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
                                    _pushPage(context, FriendDetail(appProvider: widget.appProvider, userId: users[index].uid,));
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
        title: Text("Friends"),
      ),
      body: loadStatusWidget(context) 
    );
  }
}
