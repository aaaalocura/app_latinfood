import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FindCustomer {
  final int? id;
  final String? name;
  final String? lastName;
  final String? lastName2;
  final String? phone;
  final String? address;
  final String? image;

  FindCustomer({
    this.id,
    this.name,
    this.lastName,
    this.lastName2,
    this.phone,
    this.address,
    this.image,
  });

  factory FindCustomer.fromJson(Map<String, dynamic> json) {
    return FindCustomer(
      id: json['id'],
      name: json['name'],
      lastName: json['last_name'],
      lastName2: json['last_name2'],
      phone: json['phone'],
      address: json['address'],
      image: json['image'],
    );
  }
}

class ClientDatosPage extends StatefulWidget {
  const ClientDatosPage({Key? key, required this.customerId}) : super(key: key);

  final int customerId;

  @override
  // ignore: library_private_types_in_public_api
  _ClientDatosPageState createState() => _ClientDatosPageState();
}

class _ClientDatosPageState extends State<ClientDatosPage> {
  File? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _lastName2Controller = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  FindCustomer? _customer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCustomerData(widget.customerId).then((customer) {
      setState(() {
        _customer = customer;
        _nameController.text = customer.name ?? '';
        _lastNameController.text = customer.lastName ?? '';
        _lastName2Controller.text = customer.lastName2 ?? '';
        _phoneController.text = customer.phone ?? '';
        _addressController.text = customer.address ?? '';
        _isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Error: $error');
    });
  }

  Future<void> _pickImage() async {
    // ignore: deprecated_member_use
    final pickedFile =
        // ignore: deprecated_member_use
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> editCustomerData() async {
    final url =
        'https://kdlatinfood.com/intranet/public/api/clientes/update/${widget.customerId}';
    final headers = {
      'Content-Type': 'application/json',
    };
    final updatedData = {
      'name': _nameController.text,
      'last_name': _lastNameController.text,
      'last_name2': _lastName2Controller.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
    };

    try {
      final response = await http.put(Uri.parse(url),
          headers: headers, body: jsonEncode(updatedData));

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar los datos')),
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de conexión')),
      );
      // ignore: avoid_print
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xE5FF5100),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit My Data'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          physics: const BouncingScrollPhysics(),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20.0),
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: _image != null
                              ? ClipOval(
                                  child: Image.file(_image!, fit: BoxFit.cover),
                                )
                              : _customer?.image != null
                                  ? ClipOval(
                                      child: Image.network(_customer!.image!,
                                          fit: BoxFit.cover),
                                    )
                                  : const Icon(Icons.image,
                                      size: 48, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Apellido',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _lastName2Controller,
                        decoration: const InputDecoration(
                          labelText: 'Apellido 2',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Número Telefónico',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Dirección',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          editCustomerData();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: const Color(0xE5FF5100),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

Future<FindCustomer> fetchCustomerData(int customerId) async {
  final url =
      'https://kdlatinfood.com/intranet/public/api/clientes/findUser/$customerId';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return FindCustomer.fromJson(jsonData);
  } else {
    throw Exception('Failed to load customer data');
  }
}
