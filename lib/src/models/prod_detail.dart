class Product {
  final int id;
  final String name;
  final bool estaEnWoocomerce;
  final String barcode;
  final String saborId;
  final double cost;
  final double price;
  final int stock;
  final int alerts;
  final String image;
  final String categoryId;
  final String descripcion;
  final String estado;
  final String tieneKey;
  final String keyProduct;
  final int tam1;
  final int tam2;

  Product({
    required this.id,
    required this.name,
    required this.estaEnWoocomerce,
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
    required this.tieneKey,
    required this.keyProduct,
    required this.tam1,
    required this.tam2,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      estaEnWoocomerce: json['EstaEnWoocomerce'] == "si",
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
      tieneKey: json['TieneKey'],
      keyProduct: json['KeyProduct'],
      tam1: json['tam1'],
      tam2: json['tam2'],
    );
  }
}

class RelatedProduct {
  final int id;
  final String name;
  final bool estaEnWoocomerce;
  final String barcode;
  final String saborId;
  final double cost;
  final double price;
  final int stock;
  final int alerts;
  final String image;
  final String categoryId;
  final String descripcion;
  final String estado;
  final String tieneKey;
  final String keyProduct;
  final int tam1;
  final int tam2;

  RelatedProduct({
    required this.id,
    required this.name,
    required this.estaEnWoocomerce,
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
    required this.tieneKey,
    required this.keyProduct,
    required this.tam1,
    required this.tam2,
  });

  factory RelatedProduct.fromJson(Map<String, dynamic> json) {
    return RelatedProduct(
      id: json['id'],
      name: json['name'],
      estaEnWoocomerce: json['EstaEnWoocomerce'] == "si",
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
      tieneKey: json['TieneKey'],
      keyProduct: json['KeyProduct'],
      tam1: json['tam1'],
      tam2: json['tam2'],
    );
  }
}

class ProductsData {
  final Product product;
  final List<RelatedProduct> relatedProducts;

  ProductsData({
    required this.product,
    required this.relatedProducts,
  });

  factory ProductsData.fromJson(Map<String, dynamic> json) {
    return ProductsData(
      product: Product.fromJson(json['product']),
      relatedProducts: List<RelatedProduct>.from(
        json['related_products'].map((model) => RelatedProduct.fromJson(model)),
      ),
    );
  }
}
