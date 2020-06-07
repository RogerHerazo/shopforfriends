import 'package:shopforfriends/Models/product.dart';
import 'package:shopforfriends/Models/user.dart';

class ShopCart{
  User user;
  int id;
  List <Product> products = [];
  ShopCart({this.user, this.id});

  factory ShopCart.fromJson(Map<String, dynamic> json) {
    return ShopCart(
      user: json['user'],
      id: json['id']
    );
  }

  void setProducts(List <Product> products){
    this.products = products;
  }

  Map toJson() {
    return {'user': user, 'id': id, 'products': products};
  }
}
