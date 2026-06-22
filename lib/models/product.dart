class Product {
  final int id;
  final String name;
  final String price;
  final String username;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.username,
  });

  factory Product.fromJson(
      Map<String, dynamic> json) {

    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      username: json['username'] ?? '',
    );
  }
}