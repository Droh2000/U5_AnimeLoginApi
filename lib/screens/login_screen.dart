import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:u3_anime2_api/providers/login_provider.dart';
import 'package:u3_anime2_api/widgets/alert_dialog.dart';
import 'package:u3_anime2_api/widgets/input_decoration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadDataAndNavigate();
    });
  }

  _loadDataAndNavigate() async {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      AlertAutoDialog.showMessageDialog(settings.arguments.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener el tamano de la pantalla
    final size = MediaQuery.of(context).size;
    // Scaffold es el contenedor principal de todos los widgets
    return Scaffold(
      // Empezamos a crear el cuadrado de color purpura
      // El body puede contener culaquier widget
      body: SizedBox(
        width: double.infinity, // .infinity Para ocupar todo el ancho
        height: double.infinity,
        child: Stack(
          // Es para agregar un conjunto de widgets (Para poner un Widget encima de Otro)
          children: [
            //Agregar una lista de widgets
            cajaPurpura(size),
            // Aqui creamos el Logo del Usuario
            iconoPersona(),
            // Agregar la parte del Login (El cuadrado que encierra las cajas de Texto)
            // Queremos agregar un conjunto de widgets pero que no esten enpalmados entre si como arriba solo esten arriba o abajo
            loginForm(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView loginForm(BuildContext context) {
    // Como aqui esta el boton para ingresar al sistema, aqui es donde incorporamos el provider
    final loginProvider = Provider.of<LoginProvider>(context);
    //loginProvider.getUsuarios(); // Aqui obtuvimos la lista de usuarios que nos manda la API (SE quito porque se puso en el constructor del provider)

    // Para obetner los valores de loas campos de texto instanciamos dos controladores de texto
    var txtCorreo = TextEditingController();
    var txtPassword = TextEditingController();
    // Para evitar el error de overflow al abrir el teclado le agregamos scroll al Column
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ), // Darle un espacio desde lo mas arriba de la APP hasta la parte morada
          Container(
            // Agregar un espacio desde el inicio del contenedor hacia adentro con los widgets que tenga internamente
            padding: const EdgeInsets.all(20),
            // Crear como un rectangulo
            // Crear un espacio para que no ocupe todo el ancho (Con 'symmetric' para que sea de forma horizontal)
            margin: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            //height: 100, (El container tomara automaticamente la altura segun la cantidad de widgets que tanga adentro)
            // Poner el color y las esquinas curveadas
            decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  // Sabemos que va a ser [] porque nos dice que es una lista
                  // Para poner el color de sombreado
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15, // Hacer mas grande el efecto de sombreado
                    offset: Offset(0,
                        5), // Aumentar el sombreado de la parte de abajo si quitamos el 0 afecta el sombreado en los ladoss
                  ),
                ]),
            // Agregar el texto LOGIN agregando una lista de widgets
            child: Column(
              children: [
                // Agregar espacio desde arriba hasta el texto login
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                  /*style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),*/
                ),
                const SizedBox(
                  height: 30,
                ),
                // Agregar los campos de Texto y el Boton
                Container(
                  child: Form(
                    // Habilitar los mensajes de validacion
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // Sirve para validar los datos que ingresamos
                    child: Column(
                      children: [
                        TextFormField(
                          // Caja de texto
                          // El controlador es para obtener los datos que se le ingresen
                          controller: txtCorreo,
                          keyboardType: TextInputType
                              .emailAddress, // Para que en el teclado ya nos salga el @
                          // Evitar el autocorrector porque vamos a estar escribiendo el correo
                          autocorrect: false,
                          // El campo de texto solo sea una linea para escribir
                          //********************************************************************************** */
                          // Creamos una clase del 'InputDecoration' porque es el que tiene mas lineas de codigo y
                          // reutilizar el widget y evitar copiar dos veses el 'TextFromField'
                          decoration: InputDecorations.inputDecoration(
                            hintText: 'example@email.com',
                            labelText: 'Correo electronico',
                            icono: const Icon(Icons.alternate_email_rounded),
                          ),
                          // Validador para que el usuario ingrese correctamente el correo
                          validator: (value) {
                            // value es lo que escriba el usuario
                            String pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = new RegExp(pattern);
                            // Comparar que lo ingresedao por el sistema cumpla la expresion regular
                            return regExp.hasMatch(value ??
                                    ' ') // Si la comparacion del value con la expresion regular nos devuelve algo entonces quiere decir que esta mal ingresado
                                ? null
                                : 'Ingrese bien el correo'; // Si el correo ingresa esta mal mostramos este mensaje
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          // Caja de Password
                          // El controlador es para obtener los datos que se le ingresen
                          controller: txtPassword,
                          autocorrect: false,
                          obscureText:
                              true, // Poner los * al escribir en el campo
                          decoration: InputDecorations.inputDecoration(
                            hintText: '************',
                            labelText: 'Pasword',
                            icono: const Icon(Icons.lock_clock_outlined),
                          ),
                          validator: (value) {
                            return (value != null)
                                ? null
                                : "Ingrese la contrasena";
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Boton para Iniciar Sesion
                        MaterialButton(
                          // Que tenga las esquinas redondeadas
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          disabledColor: Colors
                              .grey, // En caso que se bloque el acceso al boton salga de este color
                          color: Colors.black45,
                          // Agregar el texto dentro de un container para agregarle mejores efectos
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical:
                                    15), // Que el testo este separado de los bordes
                            // Como vamos a agregar un widget nececitamos agregar un child
                            child: const Text(
                              'Ingresar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          onPressed: () {
                            //print(loginProvider.usuarios);
                            var usuarios = loginProvider
                                .usuarios; // Obtenemos la lista de usuarios
                            // Si encontramos un email y password en la lista de usuarios (Asegurarnos que no este vacia la lista)
                            if (usuarios
                                    .where((e) => e.email == txtCorreo.text)
                                    .isNotEmpty &&
                                usuarios
                                    .where(
                                        (e) => e.password == txtPassword.text)
                                    .isNotEmpty) {
                              // Al precionar el boton queremos que nos mande al Home Screen
                              // .pushNamed
                              Navigator.pushReplacementNamed(
                                context,
                                'home',
                                arguments: txtCorreo.text,
                              );
                            } else {
                              AlertAutoDialog.showMessageDialog(
                                  "Password o contrasena Incorrecta", context);
                              //print("Password o contrasena Incorrecta");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Agregar la parte de crear una cuenta
          const SizedBox(
            height: 50,
          ),
          /*const Text(
            'Crear una nueva cuenta',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),*/
          MaterialButton(
              //color: Colors.white,
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80,
                      vertical: 15), // Que el testo este separado de los bordes
                  // Como vamos a agregar un widget nececitamos agregar un child
                  child: const Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'registrer')),
        ],
      ),
    );
  }

  SafeArea iconoPersona() {
    return SafeArea(
      // Es para asegurarse que sea bien en cualquier tipo de celular (Independientemente de la pantalla del celular la imagen del icono no se desformara)
      child: Container(
        // Configurar la pocicion para darle espacio desde arriba hasta el icono
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        // Si queremos agregar un widget hay que buscar los child
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  Container cajaPurpura(Size size) {
    return Container(
      // Aqui creamos el cuadrado de color morado
      // Para no agregar un color solido de fondo le vamos a asignar que el color se vea como que cambia de tono de un lado a otro
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // Le asignamos los dos colores (Tenga ese efecto cambiante del izquierdo al derecho)
            Color.fromRGBO(31, 31, 34, 1),
            Color.fromRGBO(30, 28, 43, 1),
          ],
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      // Agregar los circulos de fondo
      // Agregamos un Stak porque van a estar por encima del cuadrado morado
      child: Stack(
        children: [
          // pocisionar un widget como nostros queramos
          Positioned(
            child: burbuja(), // Cracion del circulo
            // Ahora tenemos que asingar la pocicon de ese circulo
            top: 90, // coordenada X
            left: 30, // Coordenada Y
          ),
          Positioned(child: burbuja(), top: -40, left: -30),
          Positioned(child: burbuja(), top: -50, right: -20),
          Positioned(child: burbuja(), bottom: -50, left: 10),
          Positioned(child: burbuja(), bottom: 120, right: 20),
        ],
      ),
    );
  }

  Container burbuja() {
    return Container(
      // Este biene siendo el circulo
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
