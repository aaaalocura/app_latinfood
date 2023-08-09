class Customer {
  int ?id;
  String ?name;
  String ?lastName;
  String ?lastName2;
  String ?email;
  String ?password;
  String ?address;
  String ?phone;
  int ?saldo;
  String ?createdAt;
  String ?updatedAt;
  String ?image;
  int ?woocommerceClienteId;
  List<Sale> sales;

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
    required this.woocommerceClienteId,
    required this.sales,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    List<dynamic> salesList = json['sale'] ?? [];
    List<Sale> sales = salesList.map((sale) => Sale.fromJson(sale)).toList();

    return Customer(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      lastName2: json['last_name2'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      phone: json['phone'],
      saldo: json['saldo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      image: json['image'],
      woocommerceClienteId: json['woocommerce_cliente_id'],
      sales: sales,
    );
  }
}

class Sale {
  int ?id;
  String ?total;
  int ?items;
  String ?cash;
  String ?change;
  String ?status;
  int ?userId;
  String ?createdAt;
  String ?updatedAt;
  int ?clientId;
  String ?statusEnvio;
  int ?customerId;
  int ?woocommerceOrderId;
  List<SaleDetail> salesDetails;

  Sale({
    required this.id,
    required this.total,
    required this.items,
    required this.cash,
    required this.change,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.clientId,
    required this.statusEnvio,
    required this.customerId,
    required this.woocommerceOrderId,
    required this.salesDetails,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    List<dynamic> salesDetailsList = json['sales_details'] ?? [];
    List<SaleDetail> salesDetails = salesDetailsList.map((detail) => SaleDetail.fromJson(detail)).toList();

    return Sale(
      id: json['id'],
      total: json['total'],
      items: json['items'],
      cash: json['cash'],
      change: json['change'],
      status: json['status'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      clientId: json['cliente_id'],
      statusEnvio: json['status_envio'],
      customerId: json['CustomerID'],
      woocommerceOrderId: json['woocommerce_order_id'],
      salesDetails: salesDetails,
    );
  }
}

class SaleDetail {
  int ?id;
  String ?price;
  int ?quantity;
  int ?productId;
  int ?saleId;
  String ?createdAt;
  String ?updatedAt;
  int ?customerId;
  int ?lotId;
  int ?scanned;
  Product ?product;

  SaleDetail({
    required this.id,
    required this.price,
    required this.quantity,
    required this.productId,
    required this.saleId,
    required this.createdAt,
    required this.updatedAt,
    required this.customerId,
    required this.lotId,
    required this.scanned,
    required this.product,
  });

  factory SaleDetail.fromJson(Map<String, dynamic> json) {
    return SaleDetail(
      id: json['id'],
      price: json['price'],
      quantity: json['quantity'],
      productId: json['product_id'],
      saleId: json['sale_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      customerId: json['CustomerID'],
      lotId: json['lot_id'],
      scanned: json['scanned'],
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  int ?id;
  String ?name;
  String ?barcode;
  int ?saborId;
  String ?cost;
  String ?price;
  int ?stock;
  int ?alerts;
  String ?image;
  int ?categoryId;
  String ?createdAt;
  String ?updatedAt;
  String ?descripcion;
  String ?estado;
  String ?estaEnWoocomerce;
  String ?tieneKey;
  String ?keyProduct;
  int ?userId;

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
    required this.createdAt,
    required this.updatedAt,
    required this.descripcion,
    required this.estado,
    required this.estaEnWoocomerce,
    required this.tieneKey,
    required this.keyProduct,
    required this.userId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
      saborId: json['sabor_id'],
      cost: json['cost'],
      price: json['price'],
      stock: json['stock'],
      alerts: json['alerts'],
      image: json['image'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      estaEnWoocomerce: json['EstaEnWoocomerce'],
      tieneKey: json['TieneKey'],
      keyProduct: json['KeyProduct'],
      userId: json['user_id'],
    );
  }
}
