import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget> [
                Text("My Shopping List"),
              ],
            ),
            Flexible(
              child: Card(
              margin: const EdgeInsets.all(5.0),
              child: //Text("hi"),
              ListView.builder(
              shrinkWrap: false,
              itemCount: widget.productlist.length,
              itemBuilder: (context,index){
              return Card(
                margin: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                      Text(widget.productlist[index].name+"\nPrecio: \$"+widget.productlist[index].price.toString()),
                    ]
                  )
                );
            })
            )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget> [
                Text("My Friend Shopping List")
              ],
            ),
            Flexible(
              child: Card(
              margin: const EdgeInsets.all(5.0),
              child: //Text("hi"),
              ListView.builder(
              shrinkWrap: false,
              itemCount: widget.productlist.length,
              itemBuilder: (context,index){
              return Card(
                margin: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                      Text(widget.productlist[index].name+"\nPrecio: \$"+widget.productlist[index].price.toString()),
                    ]
                  )
                );
            })
            )
            )
          ],
        ),
      ) 
    );
  }
}