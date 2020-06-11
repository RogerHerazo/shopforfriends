
import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopforfriends/Models/user.dart';
import 'package:shopforfriends/Pages/checkout.dart';
import 'package:shopforfriends/services/authentication.dart';

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
  var products = new List<Product>();
  List<int> cant;

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

  initState() {
    super.initState();
    _getProducts();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
  
  User user = new User(name :"Roger", email: "roger@gmail.com");
  List<Product> productlist = [];
  List<Product> friendproductlist = [];

  @override
  Widget build(BuildContext context) {
    
    
  //List<String> shopcart = [];

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
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            Container(
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Username: "),
                      ])),
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
                      RaisedButton(
                      child: Icon(Icons.add),
                      onPressed: () => {
                        productlist.add(products[index]),
                        print('Added product ' + productlist.length.toString()),
                        for (var p in productlist) {
                          print(p.toString())  
                        },
                        setState(() {
                          cant[index] += 1;
                        })
                      }),
                      RaisedButton(
                      child: Icon(Icons.remove),
                      onPressed: () => {
                        if (cant[index] > 0){
                          productlist.remove(products[index]),
                          print('Removed product ' + productlist.length.toString()),
                          for (var p in productlist) {
                            print(p.toString())  
                          },
                          setState(() {
                            cant[index] -= 1;
                          }
                        )},
                      }),
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
}

void _pushPage(BuildContext context, Widget page){
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}