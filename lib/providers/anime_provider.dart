import 'dart:convert';
import 'package:u3_anime2_api/datosuser.dart';
import 'package:u3_anime2_api/providers/urls.dart';
import 'package:flutter/material.dart';
import 'package:u3_anime2_api/models/models.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AnimeProvider extends ChangeNotifier {
  bool fixSSL = true;
  bool isLoading = true;
  List<HomeCardModel> searchList = [];
  late AnimeModel animeData = AnimeModel();
  List<CharactersModel> recommendationList = [];
  late int genreId;
  final urlApi = url;

  String _baseUrl = 'api.jikan.moe';

  //TODO: Constructor para verificar si resibimos los JSON
  AnimeProvider() {
    print('Anime Provider Inicializado');
    //getAnimesFavoritos(2);
    //getAnime();
  }

  // El enum es por las posibles categorias como Top,...
  // Por ahora solo mostrar Top
  getAnime({String category = 'Favoritos'}) async {
    searchList = [];
    isLoading = true;
    _baseUrl = 'api.jikan.moe';
    // Url BAsse a donde se dirgie, EL endpoint que nececitamos (Es lo que sta despues de /3/now_playing)
    String url = top_url, status = 'status', statusContent = '';

    switch (category.toLowerCase()) {
      case 'favoritos':
        url = top_url;
        statusContent = 'airing';
        fixSSL = false;
        break;
      case 'naruto':
        url = naruto_url;
        status = 'q';
        statusContent = 'naruto&sfw';
        fixSSL = true;
        break;
      case 'full_alchemist':
        url = fullmetal_url;
        status = 'q';
        statusContent = 'alchemist&sfw';
        fixSSL = true;
        break;
      case 'mis_favoritos':
        // Obtener los animes favoritos del usuario
        // https://api.jikan.moe/v4/anime/{id}
        Future<List<int>> idAnimes = getAnimesFavoritos(DatosUser.userid);
        List<int> list = await idAnimes;
        if (list.isNotEmpty) {
          List datas = [];
          for (int id in list) {
            //var url2 = Uri.https(_baseUrl, "v4/anime/$id");
            var url2 = Uri.https(_baseUrl, 'v4/anime/$id');
            //print("URL Entro al metodo Mis Favoritos");
            //print(url2.data);
            final response = await http.get(url2);
            //print(response.body);
            /*Map<String, dynamic> temp = json.decode(response.body);
          List datas = temp['data'];
          print("LIST DATA");
          print(datas);*/
            Map<String, dynamic> temp = json.decode(response.body);
            datas.add(json.encode(temp['data']));
          }
          //print("MAPA CON DATA");
          Map<String, dynamic> temp = {"data": ''};
          temp["data"] = (json.decode(datas.toString()));
          //print(temp["data"]);
          List dataFull = temp['data'];
          List<HomeCardModel> tempData = [];
          tempData =
              dataFull.map((data) => HomeCardModel.fromJson(data)).toList();
          searchList = tempData;
        }
        isLoading = false;
        notifyListeners();
        return;
    }

    // llamos el endpoint (Este es get)
    var url2 = Uri.http(_baseUrl, url, {
      status: statusContent,
    });
    /*if (fixSSL == true) {
      print("URL3");
      var url3 = url2.toString().substring(7, url2.toString().length);
      print(url3);
      url2 = Uri.http(_baseUrl, url3, {
        status: statusContent,
      });
    }*/
    //print("URL Entro al metodo");
    //print(url2.data);
    //if (url2.data != null) {
    final response2 = await http.get(url2);
    //print("RESponse body");
    //print(response2.body);
    Map<String, dynamic> temp = json.decode(response2.body);
    List datas = temp['data'];
    //print("TEMP DATA");
    //print(temp['data']);
    //print("LIST DATA");
    // TODO: En esta parte juntar Todos los JSON de Animes favoritos
    //print(datas);

    List<HomeCardModel> tempData = [];
    tempData = datas.map((data) => HomeCardModel.fromJson(data)).toList();
    searchList = tempData;

    isLoading = false;
    notifyListeners();
    return;
  }

  Future<http.Response> deleteFavoritos(int usuarioId, int animeId) async {
    final url =
        Uri.http(urlApi, 'api/usuarios/$usuarioId/comentarios/$animeId');

    final http.Response response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    isLoading = true;
    return response;
  }

  Future<List<int>> getAnimesFavoritos(int iduser) async {
    List<int> idAnimes = [];
    final url = Uri.http(urlApi, 'api/usuarios/$iduser/comentarios');

    final resp = await http.get(url, headers: {
      // Cuando llamemos a la web api nos puede regresar los valroes de diferentes formas
      // Aqui le indicamos como vamos a consumir la web Api
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials":
          "true", // Nuestra Web Api va a tener todos los permisos
      // El contenido va a ser un json
      "Content-type": "aplication/json",
      "Accept": "aplication/json",
    });

    List<dynamic> map = jsonDecode(resp.body);
    if (map.isNotEmpty) {
      print("LISTA de ANIMES ID:");
      print(map[0]["idAnime"]);

      for (var i = 0; i < map.length; i++) {
        idAnimes.add(map[i]["idAnime"]);
      }

      print("Longitud");
      print(idAnimes.length);
    }
    //final response = usuarioIdFromJson(resp.body);

    //usuarioId = map[0]["id"];

    notifyListeners();
    return idAnimes;
  }

  getAnimeData(int malId) async {
    //print('Entro al metodo: getAnimeData');
    isLoading = true;
    var url = Uri.https(_baseUrl, 'v4/anime/$malId');
    final response = await http.get(url);

    Map<String, dynamic> temp = json.decode(response.body);

    //print(data);
    //print(response);
    animeData = AnimeModel.fromJson(temp['data']);

    //print(animeData.genreId);
    await getRecommendationData(animeData.malId);
    isLoading = false;
    notifyListeners();
    return;
  }

  getRecommendationData(int animeId) async {
    //print('Entro al metodo: getRecommendationData');

    var url = Uri.https(_baseUrl, 'v4/anime/$animeId/characters');
    final response = await http.get(url);
    //print("Response body");
    //print(response.body);
    List<CharactersModel> tempRecommendation = [];
    Map<String, dynamic> temp = json.decode(response.body);
    List items = temp['data'];
    //print("LIST ITEMS");
    //print(items);

    tempRecommendation =
        items.map((data) => CharactersModel.fromJson(data)).toList();
    recommendationList = tempRecommendation;

    /*for (var i = 0; i != recommendationList.length; i++) {
      print(recommendationList[i].name);
    }*/

    notifyListeners();
  }
}
