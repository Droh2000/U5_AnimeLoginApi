import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u3_anime2_api/providers/anime_provider.dart';
import '../models/models.dart';
import '../screens/screen.dart';

//import 'package:u3_anime_api/widgets/home_card.dart';

class AnimeGridPage extends StatefulWidget {
  @override
  _AnimeGridPageState createState() => _AnimeGridPageState();
}

class _AnimeGridPageState extends State<AnimeGridPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await Provider.of<AnimeProvider>(context, listen: false).getAnime();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context);
    final screenHeight = device.size.height;
    final screenWidth = device.size.width;

    final movies = Provider.of<AnimeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black54,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        // Modificar para evitar que salga ese ERROR al cambiar de pestana
        child: movies.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white38,
                  strokeWidth: 5,
                ),
              )
            : RefreshIndicator(
                onRefresh: getData,
                color: Colors.black,
                strokeWidth: 2.5,
                child: LiveGrid.options(
                  padding: EdgeInsets.all(15).copyWith(left: 20, right: 20),
                  options: LiveOptions(
                    showItemInterval: Duration(
                      milliseconds: 100,
                    ),
                  ),
                  itemCount: movies.searchList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5 / 2.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index, animation) => FadeTransition(
                    opacity: Tween<double>(
                      begin: 0,
                      end: 1,
                    ).animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      // TODO:Aqui hay que mandrle como parametors la lista de las peliculas y la tarjeta  la que corresponde
                      child: HomeCard(
                        homeData: movies.searchList[index],
                        cardIndex: index,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final HomeCardModel homeData;
  final int cardIndex;

  HomeCard({
    required this.homeData,
    this.cardIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        'details',
        arguments: homeData.malId,
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: homeData.malId,
                child: /*FadeInImage(
                  // el placeholder sale algo de carga miesntras no carga la imagen
                  placeholder: const NetworkImage(
                      'https://via.placeholder.com/300x400'), // Web api que nos va a descargar una imagen
                  image: NetworkImage(homeData.imageUrl),
                  // La imagen toma la forma del contenedor padre (Que es el CLlipRReact que es el que le pusimos los bordes redondeados)
                  fit: BoxFit.cover,
                ),*/
                    Image.network(
                  homeData.imageUrl,
                  /*errorBuilder: (context, error, stackTrace) =>
                      const Text('HTTP 404'),*/
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    homeData.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
