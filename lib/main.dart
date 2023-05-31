import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u3_anime2_api/providers/providers.dart';
import 'package:u3_anime2_api/screens/screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const AppState());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// DESPUES DE CONFIGURAR EL PROVEDOR HAY QUE CONFIGURAR EL MAIN
// PARA MANEJAR EL ESTAODO DE LA APLICACION EN EL CONSUMO DE L AAPI Y HTTP
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    // Cada provider es un srvicio que consumamos de la pai
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AnimeProvider>(
          // Aqui mandamos a llamar los provedores qu tengamos
          create: (context) => AnimeProvider(),
          // Aqui solo lo creamos, No lo mandamos a llamar (Como testing lo pusimos en el constructor)
          // Como queremos saber si Funciona le indicamos que se ejecute
          lazy: false,
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
      ],
      // En segundo lugar se ejecutar ya la aplicacions
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animes',
      // Con este podmeos ponder el tema oscuro
      // con copy() podemo modificar el mapa por defecto
      theme: ThemeData.dark()
          .copyWith(appBarTheme: AppBarTheme(color: Colors.indigo)),
      initialRoute: 'login', // Ponemos el indentificador creado en el mapra
      // El home es la primera pantalla (Estas estan en su caprte)
      // Crear un sistema de rutas
      routes: {
        // La funcion anonima con _ es por el context (Todabia no vamos a poner el context pero lo dejamos asi como pendiente)
        // (Este guarda todo el arbol de widgets asi navegamos entre widgets)
        //Le podemos poner un nombre cualquiera a la instancia de la pantalla
        'login': (_) => const LoginScreen(),
        'registrer': (_) => RegistrerScreen(),
        'home': (_) => HomeScreen(),
        'details': (_) => AnimeDetailScreen(),
      }, // Por ser coleccion abrimos llaves y un mapa
    );
  }
}
