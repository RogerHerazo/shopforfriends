import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:shopforfriends/Pages/end.dart';
class Checkout extends StatefulWidget {
  const Checkout({Key key, @required this.productlist, this.friendproductlist}) : super(key: key);

  final List<Product> productlist;
  final List<Product> friendproductlist;
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: ChangeNotifierProvider<SingleModel>(
        create: (context) => SingleModel(chkstate : "Close"),
        child: _buildUI(widget.productlist, widget.friendproductlist)     
      ), 
    );
  }
}

Widget _buildUI(List<Product> productlist, List<Product> friendproductlist){
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
                          itemCount: productlist.length,
                          itemBuilder: (context,index){
                          return Card(
                            margin: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(productlist[index].name+"\nPrecio: \$"+productlist[index].price.toString()),
                              )
                            );
                        })
                      )
                    ]
                  )
                )
              )
            ),
            Expanded(
              child: Container(
                child: Card(
                  child: Column(
                    children: <Widget> [
                      Text("My Friend Shop List"),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: productlist.length,
                          itemBuilder: (context,index){
                          return Card(
                            margin: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(productlist[index].name+"\nPrecio: \$"+productlist[index].price.toString()),
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
                    
                    if(singleModel.chkstate == "Close"){
                      print("Chekout...");
                      singleModel.changeValue("Finalize");
                    }else{
                      print("Finalize...");
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

class SingleModel extends ChangeNotifier {
  String chkstate;
  SingleModel({this.chkstate});

  void changeValue(String chk) {
    chkstate = chk;
    notifyListeners(); 
  }
}

void _pushPage(BuildContext context, Widget page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute<void>(builder: (_) => page), (route) => false);
}