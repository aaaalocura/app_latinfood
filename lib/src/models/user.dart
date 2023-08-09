import 'dart:convert';

User welcomeFromJson(String str) => User.fromJson(json.decode(str));

String welcomeToJson(User data) => json.encode(data.toJson());

class User {
    int? id;
    String? name;
    String? lastName;
    String? lastName2;
    String? email;
    String? password;
    String? address;
    String? image;
    int? saldo;
    String? phone;
    String? sessionToken;


    User({
         this.id,
         this.name,
         this.lastName,
         this.lastName2,
         this.email,
         this.password,
         this.address,
         this.image,
         this.saldo,
         this.phone,
         this.sessionToken

    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        lastName: json["last_name"],
        lastName2: json["last_name2"],
        email: json["email"],
        password: json["password"],
        address: json["address"],
        image: json["image"],
        saldo: json["saldo"],
        phone: json["phone"],
        sessionToken: json["session_token"],

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "last_name": lastName,
        "last_name2": lastName2,
        "email": email,
        "password": password,
        "address": address,
        "image": image,
        "saldo": saldo,
        "phone": phone,
        "session_token": sessionToken,

    };
}
