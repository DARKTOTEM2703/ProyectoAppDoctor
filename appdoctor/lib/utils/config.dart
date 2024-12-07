import 'package:flutter/material.dart'; // Importamos el paquete Material

class Config {
  // Datos de la consulta de medios
  static MediaQueryData? mediaQueryData;
  static double? anchoDePantalla; // Ancho de la pantalla
  static double? altoDePantalla; // Altura de la pantalla

  // Método para inicializar las variables con el contexto
  static void init(BuildContext context) {
    mediaQueryData =
        MediaQuery.of(context); // Obtenemos los datos de la consulta de medios
    anchoDePantalla =
        mediaQueryData!.size.width; // Obtenemos el ancho de la pantalla
    altoDePantalla =
        mediaQueryData!.size.height; // Obtenemos la altura de la pantalla
  }

  //funcin para acceder a las dimensiones de pantalla
  static get obtenerAnchoDePantalla {
    return anchoDePantalla;
  }

  static get obtenerAltoDePantalla {
    return altoDePantalla;
  }

  // Espacios predefinidos
  static const espacioPequeno = SizedBox(height: 25); // Espacio fijo de 25
  static final espacioMediano = SizedBox(
      height: altoDePantalla! *
          0.05); // Espacio fijo dependiendo de la altura de la pantalla
  static final espacioGrande = SizedBox(
    height: altoDePantalla! * 0.08,
  ); // Espacio fijo dependiendo de la altura de la pantalla

  // Estilos de bordes para entradas de texto
  static const bordeRedondeado = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ); // Bordes redondeados

  static const bordeEnfocado = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.greenAccent, width: 2),
  ); // Bordes enfocados con color verde cuando se selecciona
  static const bordeError = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: Colors.redAccent, width: 2),
  ); // Bordes de error con color rojo cuando hay un error
  static const primaryColor = Colors.greenAccent; // Color primario verde
}
