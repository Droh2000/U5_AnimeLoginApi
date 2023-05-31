import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/input_decoration.dart';

class RegistrerScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  var txtNombre = TextEditingController();
  var txtApellidoP = TextEditingController();
  var txtApellidoM = TextEditingController();
  var txtEmail = TextEditingController();
  var txtpass = TextEditingController();
  var txtconfirmPass = TextEditingController();

  //const RegistrerScreen({super.key});

  void clearText() {
    txtNombre.clear();
    txtApellidoP.clear();
    txtApellidoM.clear();
    txtEmail.clear();
    txtpass.clear();
    txtconfirmPass.clear();
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
            // Agregar la parte del registro
            registrerForm(context),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView registrerForm(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    // Obtener el contenido del campo para confirmar la password
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 170,
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
                  'Registrarse',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 30,
                ),
                // Agregar los campos de Texto y el Boton
                Container(
                  child: Form(
                    key: formKey,
                    // Habilitar los mensajes de validacion
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // Sirve para validar los datos que ingresamos
                    child: Column(
                      children: [
                        TextFormField(
                          controller: txtNombre,
                          keyboardType: TextInputType.name,
                          autocorrect: true,
                          decoration: InputDecorations.inputDecoration(
                            hintText: " ",
                            labelText: "Nombre",
                            icono: const Icon(Icons.face),
                          ),
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Ingrese el nombre",
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: txtApellidoP,
                          keyboardType: TextInputType.name,
                          autocorrect: true,
                          decoration: InputDecorations.inputDecoration(
                            hintText: " ",
                            labelText: "Apellido Paterno",
                            icono: const Icon(Icons.attribution),
                          ),
                          validator: (value) => value!.isNotEmpty
                              ? null
                              : "Ingrese el apellido paterno",
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: txtApellidoM,
                          keyboardType: TextInputType.name,
                          autocorrect: true,
                          decoration: InputDecorations.inputDecoration(
                            hintText: " ",
                            labelText: "Apellido materno",
                            icono: const Icon(Icons.attractions),
                          ),
                          validator: (value) =>
                              value!.isNotEmpty ? null : "Ingrese el dato",
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          // El controlador es para obtener los datos que se le ingresen
                          controller: txtEmail,
                          keyboardType: TextInputType
                              .emailAddress, // Para que en el teclado ya nos salga el @
                          autocorrect: false,
                          decoration: InputDecorations.inputDecoration(
                            hintText: 'example@email.com',
                            labelText: 'Correo electronico',
                            icono: const Icon(Icons.alternate_email_rounded),
                          ),
                          validator: (value) {
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
                          controller: txtpass,
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
                        TextFormField(
                          controller: txtconfirmPass,
                          autocorrect: false,
                          obscureText:
                              true, // Poner los * al escribir en el campo
                          decoration: InputDecorations.inputDecoration(
                            hintText: '************',
                            labelText: 'Confirmar Pasword',
                            icono: const Icon(Icons.lock_clock_outlined),
                          ),
                          validator: (value) {
                            if (value == null) return "Ingrese la contrasena";
                            if (value != txtpass.text)
                              return "No coinicide el Password";
                            return null;
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
                              'Registrarse',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          onPressed: () {
                            Map<String, dynamic> data = {
                              'nombre': txtNombre.text,
                              'apellidoPaterno': txtApellidoP.text,
                              'apellidoMaterno': txtApellidoM.text,
                              'email': txtEmail.text,
                              "password": txtpass.text,
                            };
                            loginProvider.postUsuario(data).then((result) {
                              if (result.statusCode == 200) {
                                loginProvider.getUsuarios();
                                clearText();
                                Navigator.pushReplacementNamed(context, 'login',
                                    arguments: "Registro Exitoso");
                              } else {
                                AlertAutoDialog.showMessageDialog(
                                    "Error al registrarse", context);
                                clearText();
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              color: Colors.blueAccent,
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pushReplacementNamed(
                                  context, 'login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          Icons.person_add,
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
