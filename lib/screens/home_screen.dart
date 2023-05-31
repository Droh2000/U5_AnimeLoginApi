import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:u3_anime2_api/datosuser.dart';
import 'package:u3_anime2_api/providers/providers.dart';
import '../screens/screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int idUser = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _obtenerIdUsuario();
    });
  }

  _obtenerIdUsuario() async {
    final email = ModalRoute.of(context)?.settings.arguments as String;

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    var usuarioid = loginProvider.getUsuarioId(email);
    Future<int> _futureOfList = usuarioid;
    int list = await _futureOfList;
    idUser = list;
    DatosUser.userid = list;
  }

  getData(String name) async {
    await Provider.of<AnimeProvider>(context, listen: false)
        .getAnime(category: name);
  }

  Widget _buttonBuilder(String name, int myIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = myIndex;
          getData(name);
        });
      },
      child: FittedBox(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 2.5),
          decoration: BoxDecoration(
            color: _selectedIndex == myIndex ? Colors.white : Colors.black54,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: .8,
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == myIndex ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final animesProvider = Provider.of<AnimeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text('Animes'),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.login,
              color: Colors.white,
            ),
            tooltip: 'Cerrar Sesion',
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 27,
            margin: EdgeInsets.only(bottom: 13, top: 13),
            child: ListView(
              //padding: EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              children: [
                _buttonBuilder('Favoritos', 0),
                _buttonBuilder('Naruto', 1),
                _buttonBuilder('Full_Alchemist', 2),
                _buttonBuilder('Mis_Favoritos', 3),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: AnimeGridPage(),
            ),
          ),
        ],
      ),
      //),
    );
  }
}
