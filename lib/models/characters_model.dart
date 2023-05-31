import 'dart:convert';
import 'models.dart';

class CharactersModel {
  int malId;
  String url;
  String imageUrl;
  String name;

  CharactersModel({
    required this.malId,
    required this.url,
    required this.imageUrl,
    required this.name,
  });

  factory CharactersModel.fromRawJson(String str) =>
      CharactersModel.fromJson(json.decode(str));

  factory CharactersModel.fromJson(Map<String, dynamic> json) {
    return CharactersModel(
      malId: json['character']['mal_id'],
      url: json['character']['url'],
      imageUrl: json['character']['images']['jpg']['image_url'],
      name: json['character']['name'],
    );
  }
}
