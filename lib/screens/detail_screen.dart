import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:u3_anime2_api/datosuser.dart';
import '../providers/anime_provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../screens/screen.dart';
import '../widgets/alert_dialog.dart';

class AnimeDetailScreen extends StatefulWidget {
  @override
  _DetailsScreen createState() => _DetailsScreen();
}

class _DetailsScreen extends State<AnimeDetailScreen> {
  //const DetailsScreen({super.key});
  var _isInit = true;

  // Se implemento este metodo para que no se este mandando a llamar infinitas veses el provider y consumiendo resusos
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      late int animeId = ModalRoute.of(context)!.settings.arguments as int;
      Provider.of<AnimeProvider>(context, listen: false).getAnimeData(animeId);
      Provider.of<LoginProvider>(context, listen: false)
          .getExisteAnimeEnUsuario(DatosUser.userid, animeId);
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    // Recibir argumentos (Asi es como se pasan los argumentos de una pantalla a otra)
    // No puede ser nulo ? y debemos agregar una condicional con ??
    //final String movie =
    //    ModalRoute.of(context)?.settings.arguments.toString() ?? 'Sin nombre';

    // Pasar los argumentos de la pantalla
    //int animeId = ModalRoute.of(context)!.settings.arguments as int;
    //Provider.of<AnimeProvider>(context, listen: false).getAnimeData(animeId);

    // Variables Generales
    final dataProvider = Provider.of<AnimeProvider>(context);
    final AnimeModel animeData = dataProvider.animeData;
    //final animeData = ModalRoute.of(context)?.settings.arguments as AnimeModel;

    return Scaffold(
      body: !dataProvider.isLoading
          ? CustomScrollView(
              // Vamos a ahcerlo personalizado
              slivers: [
                // Son widets con un comportamieito
                _CustmoAppbar(animeData: animeData),
                SliverList(
                    delegate: SliverChildListDelegate([
                  _PosterAndTitle(
                      animeData: animeData, dataProvider: dataProvider),
                  _Overview(
                    animeData: animeData,
                  ),
                  _Characters(dataProvider: dataProvider)
                ])),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _Characters extends StatelessWidget {
  final dataProvider;

  const _Characters({super.key, required this.dataProvider});

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final screenWidth = device.size.width;

    return Container(
      height: screenWidth / 2,
      width: screenWidth,
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(bottom: 35),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: dataProvider.recommendationList.length,
        itemBuilder: (context, index) => RecommendationCard(
          recData: dataProvider.recommendationList[index],
        ),
      ),
    );
  }
}

class _CustmoAppbar extends StatelessWidget {
  final AnimeModel animeData;

  const _CustmoAppbar({super.key, required this.animeData});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true, // PAra que no desparessca (Si no que se haga chica)
      // Widget para que se ajuste al tamano
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        // Eliminar el paddin (Es el epsaico feoc que sale abajo del titulo
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          // El titulo en la parte de abajo al centor
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          child: Text(
            animeData.title,
            style: TextStyle(fontSize: 18),
          ),
        ), // Esto es lo que va dentro dle appvar
        background: Hero(
          tag: animeData.malId,
          child: Image.network(
            animeData.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final AnimeModel animeData;
  final dataProvider;

  const _PosterAndTitle(
      {super.key, required this.animeData, this.dataProvider});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(
        // Este esta arriba de la pelicula
        top: 20,
      ),
      padding: const EdgeInsets.symmetric(
        // este de las orillas
        horizontal: 20,
      ),
      // Renglones para poner las coasuna al lado de otra
      child: Row(
        // Vamos a dividir la fila en hijos
        children: [
          // El primer hijo va a ser una imagen con bordes redondesdos
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.multiply),
              child: Hero(
                tag: animeData.malId + 1,
                child: Image.network(
                  animeData.imageUrl,
                  fit: BoxFit.cover,
                  height: 180.0, // Hacer mas pequena la imagen
                ),
              ),
            ),
          ),
          // Agregar contenido al lado de la imagen
          // Dentro del ROW ponemos un Columan (Poner el titurlo y subtitulo y estrellas como hijo al lado de la imagen)
          const SizedBox(
            width: 20,
          ), // Espacio del ancho
          // Para que toda la columna se expanda en todo el espacio sobrante
          Expanded(
            child: Column(
              // Para que todo este justiicado a la izquierda
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animeData.title,
                  style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  animeData.titleEnglish,
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                // Agregamos otro ROW para las Estrellas
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    /*Text(
                      animeData.rating,
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),*/
                    Visibility(
                      visible: !loginProvider.existeAnime,
                      child: MaterialButton(
                        //color: Colors.blueAccent,
                        child: const Text(
                          "Agregar a favoritos",
                          style: TextStyle(fontSize: 16),
                        ),
                        /*const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),*/
                        onPressed: () {
                          Map<String, dynamic> data = {
                            'idAnime': animeData.malId,
                          };
                          loginProvider
                              .postAnimeFavorito(data, DatosUser.userid)
                              .then((result) {
                            if (result.statusCode == 200) {
                              AlertAutoDialog.showMessageDialog(
                                  "Agregado a favoritos", context);
                            } else {
                              AlertAutoDialog.showMessageDialog(
                                  "Ya esta agregado", context);
                            }
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: loginProvider.existeAnime,
                      child: MaterialButton(
                        //color: Colors.blueAccent,
                        child: const Text(
                          "Quitar de favoritos",
                          style: TextStyle(fontSize: 16),
                        ),
                        /*const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),*/
                        onPressed: () {
                          //TODO: Endpoint DELETE
                          dataProvider
                              .deleteFavoritos(
                                  DatosUser.userid, animeData.malId)
                              .then((result) {
                            if (result.statusCode == 204) {
                              /*AlertAutoDialog.showMessageDialog(
                                  "Eliminado Correctamente", context);*/
                              dataProvider.getAnime(category: 'Mis_Favoritos');
                            } else {
                              AlertAutoDialog.showMessageDialog(
                                  "Ya se elimino", context);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final AnimeModel animeData;
  const _Overview({super.key, required this.animeData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        animeData.synopsis,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
