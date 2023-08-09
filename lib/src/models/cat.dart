class Product {
  final int id;
  final String? name;
  final double? cost;
  final double? price;
  final int? stock;
   final String? image;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    required this.cost,
    required this.price,
    required this.stock,
       required this.image,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      cost: double.parse(json['cost']),
      price: double.parse(json['price']),
      stock: json['stock'],
      image: json['image'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}
