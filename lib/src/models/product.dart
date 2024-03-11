
class Product {
  final int id;
  final String name;
  final String barcode;
  final String? saborId;
  final double  cost;
  final double  price;
  final int stock;
  final int alerts;
  final String? image;
  final String categoryId;
  final String descripcion;
  final String? estado;
  final String? estaEnWoocomerce;
  final String tieneKey;
  final String? keyProduct;
  final int? userId;
  final int? tam1;
  final int? tam2;
  final int? is_favorite;


  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.saborId,
    required this.cost,
    required this.price,
    required this.stock,
    required this.alerts,
    required this.image,
    required this.categoryId,

    required this.descripcion,
    required this.estado,
    required this.estaEnWoocomerce,
    required this.tieneKey,
    required this.keyProduct,
    required this.userId,
    required this.tam1,
    required this.tam2,
    // ignore: non_constant_identifier_names
    required this.is_favorite
   
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      saborId: json['sabor_id'],
      cost: json['cost'].toDouble(),
      price: json['price'].toDouble(),
      stock: json['stock'],
      alerts: json['alerts'],
      image: json['image'],
      categoryId: json['category_id'],
 
      descripcion: json['descripcion'],
      estado: json['estado'],
      estaEnWoocomerce: json['EstaEnWoocomerce'],
      tieneKey: json['TieneKey'],
      keyProduct: json['KeyProduct'],
      userId: json['user_id'],
      tam1: json['tam1'],
      tam2: json['tam2'],
      is_favorite:json['is_favorite']
      
    );
  }

  toJson() {}
}
