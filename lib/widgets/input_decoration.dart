import 'package:flutter/material.dart';

//      Creacion de los Campos de Texto y Contrasena
// El nombre de la clase no debe tener el mismo nombre que el del widget
// porque aqui vamos a mandar a llamar la clase 'InputDecoration' original de flutter
class InputDecorations {
  // Hacemos que la clase resiva tres parametros porque cada uno tendra definido el "HintText","labelText","prefixIcon"
  static InputDecoration inputDecoration(
      { // este es el widget original de Flutter
      required String hintText,
      required String labelText,
      required Icon icono}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
        ),
      ),
      // Saber en cual campo tenemos el FOCO (Al tenerlo cambia de color)
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
          width: 2,
        ),
      ),
      hintText:
          hintText, // Es una ayuda para mostrar que ingresar al campo de texto
      labelText: labelText, // Es el texto de arriba que sale del campo
      prefixIcon: icono,
    );
  }
}
