// Aqui vamos a guardar todas las propiedades de la tabla usuario (Id,Email,Password)
// Esta es la que vamos a mandar a llamar en el Provider
import 'dart:convert';

// Este metodo nos convierte lo que tenemos en la web api a una lista de usuarios
// por defecto de la Api obtenemos un JSON y de aqui lo convertimos a la lista
List<Usuario> usuarioFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
  // Estos son los datos que nos regresa nuestra WebAPI
  String email;
  String password;

  Usuario({
    // Siempre debemos obtener estos valores
    required this.email,
    required this.password,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}
