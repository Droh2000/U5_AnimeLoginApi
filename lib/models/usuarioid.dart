import 'dart:convert';

List<UsuarioId> usuarioIdFromJson(String str) =>
    List<UsuarioId>.from(json.decode(str).map((x) => UsuarioId.fromJson(x)));

String usuarioIdToJson(List<UsuarioId> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsuarioId {
  int id;

  UsuarioId({
    required this.id,
  });

  factory UsuarioId.fromJson(Map<String, dynamic> json) => UsuarioId(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
