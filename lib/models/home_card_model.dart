import 'dart:convert';
import 'models.dart';

class HomeCardModel {
  int malId;
  String url;
  String imageUrl;
  String title;

  HomeCardModel({
    required this.malId,
    required this.url,
    required this.imageUrl,
    required this.title,
  });

  factory HomeCardModel.fromRawJson(String str) =>
      HomeCardModel.fromJson(json.decode(str));

  factory HomeCardModel.fromJson(Map<String, dynamic> json) {
    return HomeCardModel(
      malId: json['mal_id'],
      url: json['url'],
      imageUrl: json['images']['jpg']['image_url'],
      title: json['title'],
    );
  }
}
