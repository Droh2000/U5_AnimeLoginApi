import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:u3_anime2_api/models/models.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

import '../widgets/alert_dialog.dart';

class LoginProvider with ChangeNotifier {
  List<Usuario> usuarios = [];
  //int usuarioId = 0;
  bool existeAnime = false;
  int? statusCode;
  final urlApi = url;

  // Creacion del constructor
  // para que al llamar el provider en la interfaz de login llame automaticamente el metodo para obtener los usarios
  // Asi no mandamos a llamar directamente al metodo ya que eso hara que se este mandando a llamar infinitamente el metodo consumiendo recursos
  LoginProvider() {
    getUsuarios();
    statusCode = 200;
    //postUsuario();
  }

  // Metodo que nos va a consumir la webApi que nos va a llenar la lista de usuario
  // Si da Error (Poner BreackPoint -- Debug y F10 para ir avanzando y ver si obtubo bien los datos)
  getUsuarios() async {
    // URL: IP:PORT/api/usuario
    final url = Uri.http(urlApi, 'api/usuario');
    // GET = Es para obtener datos de la API, POST=Mandar datos de la App a la API (Registrar un usuario)
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
    // Manejar la respuesta que nos manda la Web APi, resp.body nos manda solo el JSON
    final response = usuarioFromJson(resp.body);
    // Almacenamos la lista de usuarios
    usuarios = response;

    // Siempre que haya un cambio en la lista de usuarios
    // esto le dira a lo que sea que este usando la lista de usuarios que se actualize (Como cuando mostremos los datos en un widget)
    notifyListeners();
  }

  Future<int> getUsuarioId(String email) async {
    final url = Uri.http(urlApi, 'api/usuario/$email');

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
    //print("EL ID ES:");
    //print(map[0]["id"]);

    //final response = usuarioIdFromJson(resp.body);

    //usuarioId = map[0]["id"];

    notifyListeners();
    return map[0]["id"];
  }

  Future<bool> getExisteAnimeEnUsuario(int usuarioId, int animeId) async {
    final url = Uri.http(
        urlApi,
        'api/usuarios/$usuarioId/comentarios/existeAnime',
        {'IdAnime': '$animeId'});

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

    bool map = jsonDecode(resp.body);
    existeAnime = map;

    notifyListeners();
    return map;
  }

  Future<http.Response> postUsuario(Map<String, dynamic> data) async {
    final url = Uri.http(urlApi, 'api/usuario');

    String body = json.encode(data);

    final resp = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );

    statusCode = resp.statusCode;

    if (resp.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      print('success');
    } else {
      print('error');
    }
    notifyListeners();
    return resp;
  }

  Future<http.Response> postAnimeFavorito(
      Map<String, dynamic> data, int iduser) async {
    final url = Uri.http(urlApi, 'api/usuarios/$iduser/comentarios');

    String body = json.encode(data);

    final resp = await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
    );

    statusCode = resp.statusCode;

    if (resp.statusCode == 200) {
      //Or put here your next screen using Navigator.push() method
      print('success');
    } else {
      print('error');
    }
    notifyListeners();
    return resp;
  }
}
