import 'dart:convert';

List<Registro> registroFromJson(String str) =>
    List<Registro>.from(json.decode(str).map((x) => Registro.fromJson(x)));

String registroToJson(List<Registro> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Registro {
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String email;
  String password;

  Registro({
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.email,
    required this.password,
  });

  factory Registro.fromJson(Map<String, dynamic> json) => Registro(
        nombre: json["nombre"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "email": email,
        "password": password,
      };
}
