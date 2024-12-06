//Establecemos constantes para la configuración de la aplicación
import 'package:flutter/material.dart'; //Importamos el paquete material

class Config {
  static MediaQueryData? mediaQueryData; //Datos de la consulta de medios
  static double? screenWidth; //Ancho de la pantalla
  static double? screenHeight; //Altura de la pantalla

  static void init(BuildContext context) {
    mediaQueryData =
        MediaQuery.of(context); //Obtenemos los datos de la consulta de medios
    screenWidth =
        mediaQueryData!.size.width; //Obtenemos el ancho de la pantalla
    screenHeight =
        mediaQueryData!.size.height; //Obtenemos la altura de la pantalla
  }
}
