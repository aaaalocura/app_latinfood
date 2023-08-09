class FindCustomer {
  final String? name;
  final String? lastName;
  final String? lastName2;
  final String? email;
  final String? phone;
  final String? address;
  final String? password;
  final int? saldo;
  final String? image;
  final String? woocommerceClienteId;

  FindCustomer({
    required this.name,
    required this.lastName,
    required this.lastName2,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    required this.saldo,
    required this.image,
    required this.woocommerceClienteId,
  });

factory FindCustomer.fromJson(Map<String, dynamic> json) {
  String? imageUrl = json['image']; // Obtiene la URL de la imagen del JSON

  // Verifica si la imagen proviene de "https://kdlatinfood.com/intranet/public/storage/customers"
  if (imageUrl == 'https://kdlatinfood.com/intranet/public/storage/customers') {
    imageUrl = null; // Establece la imagen como null si la URL coincide
  }

  return FindCustomer(
    name: json['name'],
    lastName: json['last_name'],
    lastName2: json['last_name2'],
    email: json['email'],
    phone: json['phone'],
    address: json['address'],
    password: json['password'],
    saldo: json['saldo'],
    image: imageUrl,
    woocommerceClienteId: json['woocommerce_cliente_id'],
  );
}

}
