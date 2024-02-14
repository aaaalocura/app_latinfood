class Sale {
  final int id;
  final String total;
  final int items;
  final String cash;
  final String change;
  final String status;
  final int? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? clienteId;
  final String statusEnvio;
  final int customerId;
  final List<SalesDetail> salesDetails;
  final Customer customer;

  Sale({
    required this.id,
    required this.total,
    required this.items,
    required this.cash,
    required this.change,
    required this.status,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.clienteId,
    required this.statusEnvio,
    required this.customerId,
    required this.salesDetails,
    required this.customer,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['data']['id'],
      total: json['data']['total'],
      items: json['data']['items'],
      cash: json['data']['cash'],
      change: json['data']['change'],
      status: json['data']['status'],
      userId: json['data']['user_id'],
      createdAt: DateTime.parse(json['data']['created_at']),
      updatedAt: DateTime.parse(json['data']['updated_at']),
      clienteId: json['data']['cliente_id'],
      statusEnvio: json['data']['status_envio'],
      customerId: json['data']['CustomerID'],
      salesDetails: (json['data']['sales_details'] as List)
          .map((detailJson) => SalesDetail.fromJson(detailJson))
          .toList(),
      customer: Customer.fromJson(json['data']['customer']),
    );
  }
}

class SalesDetail {
  final int id;
  final String price;
  final int quantity;
  final int productId;
  final int saleId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;

  SalesDetail({
    required this.id,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.saleId,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory SalesDetail.fromJson(Map<String, dynamic> json) {
    return SalesDetail(
      id: json['id'],
      price: json['price'],
      quantity: json['quantity'],
      productId: json['product_id'],
      saleId: json['sale_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String barcode;
  final String cost;
  final String price;
  final int stock;
  final String image;
  final String descripcion;
  final String estado;
  final String tieneKey;
  final String keyProduct;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.cost,
    required this.price,
    required this.stock,
    required this.image,
    required this.descripcion,
    required this.estado,
    required this.tieneKey,
    required this.keyProduct,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      cost: json['cost'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      tieneKey: json['TieneKey'],
      keyProduct: json['KeyProduct'],
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String lastName;
  final String lastName2;
  final String email;
  final String address;
  final String phone;
  final int saldo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;
  final String notificationToken;

  Customer({
    required this.id,
    required this.name,
    required this.lastName,
    required this.lastName2,
    required this.email,
    required this.address,
    required this.phone,
    required this.saldo,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.notificationToken,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      lastName2: json['last_name2'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      saldo: json['saldo'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      image: json['image'],
      notificationToken: json['notification_token'],
    );
  }
}
