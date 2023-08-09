class ProductFavorite {
  int id;
  String? name;
  String? barcode;
  double? cost;
  double? price;
  int? stock;
  int? alerts;
  String? image;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? estado;
  bool isFavorite = false;

  ProductFavorite({
    required this.id,
    required this.name,
    required this.barcode,
    required this.cost,
    required this.price,
    required this.stock,
    required this.alerts,
    required this.image,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.estado,
     this.isFavorite = false,
  });

  // Constructor para mapear los datos de JSON a objeto Dart
  factory ProductFavorite.fromJson(Map<String, dynamic> json) {
    return ProductFavorite(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      cost: double.parse(json['cost']),
      price: double.parse(json['price']),
      stock: json['stock'],
      alerts: json['alerts'],
      image: json['image'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      description: json['descripcion'],
      estado: json['estado'],
    );
  }
}
