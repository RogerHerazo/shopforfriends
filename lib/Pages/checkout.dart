import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:shopforfriends/Pages/end.dart';

enum LoadStatus {
  NOT_DETERMINED,
  VIEW_LOADED,
}

class Checkout extends StatefulWidget { 
  const Checkout({Key key, @required this.shopcart, this.userId}) : super(key: key);

  final List<Product> shopcart;
  final String userId;
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  LoadStatus loadStatus = LoadStatus.VIEW_LOADED;

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

    // await Firestore.instance.collection('users')
    //   .document(widget.userId)
    //   .updateData({
    //       'shopcart': FieldValue.delete()
    //     });

    // setState(() {
    //   loadStatus = LoadStatus.VIEW_LOADED;
    // });
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
                  child: Column(
                    children: <Widget> [
                      Text("My Shopping List"),
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
            Consumer<SingleModel>(
              builder: (context, singleModel, child){
                return Container(
                  child: RaisedButton(
                onPressed: () {
                    
                    if(singleModel.chkstate == "Pay"){
                      print("Pay...");
                      singleModel.changeValue("End checkout");
                      _createPayment();
                    }else{
                      print("End checkout...");
                      _pushPage(context, End());
                    }
                    
                  },
                  child: Text(singleModel.chkstate),
                  ),
                );
              },
            )
          ],
        ),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: ChangeNotifierProvider<SingleModel>(
        create: (context) => SingleModel(chkstate : "Pay"),
        child: _buildUI(widget.shopcart)     
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
