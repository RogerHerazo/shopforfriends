
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopforfriends/Models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var products = new List<Product>();

  _getProducts() async {
    final http.Response response = await http.get(
      'https://frutiland.herokuapp.com/search'
    );
    print('${response.body}');
    print('${response.statusCode}');
    setState(() {
      Iterable list = json.decode(response.body);
      products = list.map((model) => Product.fromJson(model)).toList();
    });
  }

  initState() {
    super.initState();
    _getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
                    print("Chekout");
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

                      })
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