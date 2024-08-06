class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String? image_path;

  /// Creates a [Product] instance with the given parameters.
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      this.image_path});

  /// Creates a [Product] instance from a JSON object.
  ///
  /// [json] - A map containing the product's data in key-value pairs.
  /// Returns a new [Product] object with data populated from the JSON map.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      image_path: json['image_path'],
    );
  }
}
