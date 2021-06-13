class Product {
  int id;
  int categoryId;
  String name;
  String price;
  String img;

  Product({this.id, this.categoryId, this.name, this.price, this.img});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['categoryId'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryId'] = this.categoryId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['img'] = this.img;
    return data;
  }
}