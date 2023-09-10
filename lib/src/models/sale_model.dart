class Sale {
  final int id;
  final String total;
  final int items;
  final double cash;
  final double? change;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String statusEnvio;
  // ignore: non_constant_identifier_names
  final int? CustomerID;
  final int? woocommerceOrderID;
  final List<SaleDetail> salesDetails;
  final Customer customer;

  Sale({
    required this.id,
    required this.total,
    required this.items,
    required this.cash,
    required this.change,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.statusEnvio,
    // ignore: non_constant_identifier_names
    required this.CustomerID,
    required this.woocommerceOrderID,
    required this.salesDetails,
    required this.customer,
  });
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      total: json['total'].toString(), // Corregir el tipo a String
      items: json['items'],
      cash: double.parse(json['cash'].toString()), // Corregir el tipo a double
      change:
          double.parse(json['change'].toString()), // Corregir el tipo a double
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      statusEnvio: json['status_envio'],
      CustomerID: json['customer_id'],
      woocommerceOrderID: json['woocommerce_order_id'],
      salesDetails: (json['sales_details'] as List<dynamic>)
          .map((detail) => SaleDetail.fromJson(detail))
          .toList(),
      customer: Customer.fromJson(json['customer']),
    );
  }
}

class SaleDetail {
  final int id;
  final double price;
  final int quantity;
  final int productID;
  final int saleID;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int customerID;
  final int lotID;
  final int scanned;
  final Product product;

  SaleDetail({
    required this.id,
    required this.price,
    required this.quantity,
    required this.productID,
    required this.saleID,
    required this.createdAt,
    required this.updatedAt,
    required this.customerID,
    required this.lotID,
    required this.scanned,
    required this.product,
  });
  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      id: json['id'],
         price: double.parse(json['price'].toString()), // Corregir el tipo a double
      quantity: json['quantity'],
      productID: json['product_id'],
      saleID: json['sale_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      customerID: json['customer_id'] ?? 0, // Asigna 0 si 'customer_id' es null
      lotID: json['lot_id'] ?? 0, // Asigna 0 si 'lot_id' es null
      scanned: json['scanned'] ?? 0, // Asigna 0 si 'scanned' es null
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String barcode;
  final int saborID;
    final double cost; // Quita los paréntesis ()
  final double price; // Quita los paréntesis ()

  final int stock;
  final int alerts;
  final String image;
  final int categoryID;
  final String descripcion;
  final String estado;
  final dynamic keyProduct;
  final int userID;

  Product({
    required this.id,
    required this.name,
    required this.barcode,
    required this.saborID,
    required this.cost,
    required this.price,
    required this.stock,
    required this.alerts,
    required this.image,
    required this.categoryID,
    required this.descripcion,
    required this.estado,
    required this.keyProduct,
    required this.userID,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      saborID: json['sabor_id'],
       cost: double.parse(json['cost'].toString()), // Corregir el tipo a double
      price: double.parse(json['price'].toString()), // Corregir el tipo a double
      stock: json['stock'],
      alerts: json['alerts'],
      image: json['image'],
      categoryID: json['category_id'],
      descripcion: json['descripcion'],
      estado: json['estado'],
     
      keyProduct: json['keyProduct'],
      userID: json['user_id'],
    );
  }
}

class Customer {
  final int id;
  final String name;
  final String lastName;
  final String lastName2;
  final String email;
  final String password;
  final String address;
  final String phone;
  final double saldo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String image;
  final dynamic woocommerceClienteID;

  Customer({
    required this.id,
    required this.name,
    required this.lastName,
    required this.lastName2,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.saldo,
    required this.createdAt,
    required this.updatedAt,
    required this.image,
    required this.woocommerceClienteID,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      lastName2: json['last_name2'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      phone: json['phone'],
      saldo: json['saldo'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      image: json['image'],
      woocommerceClienteID: json['woocommerce_cliente_id'],
    );
  }
}