class Product{
  static int counter = 0;
  int index;
  double price;
  String name;
  String category;
  Product({this.index, this.price, this.name, this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    counter = counter + 1;
    return Product(
      index: counter,
      price: json['price'],
      name: json['name'],
      category: json['category'],
    );
  }

  Map toJson() {
    return {'index': index, 'price': price, 'name': name, 'category': category};
  }

  @override
  String toString(){
    return('price: '+ price.toString() + ' name: '+ name + ' category: '+ category);
  }
}
