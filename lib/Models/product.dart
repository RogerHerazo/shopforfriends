class Product{
  double price;
  String name;
  String category;
  Product({this.price, this.name, this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      price: json['price'],
      name: json['name'],
      category: json['category'],
    );
  }

  Map toJson() {
    return {'price': price, 'name': name, 'category': category};
  }

  @override
  String toString(){
    return('price: '+ price.toString() + ' name: '+ name + ' category: '+ category);
  }
}
