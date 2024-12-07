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

  // Getters para acceder a las dimensiones de pantalla
  static double get obtenerAnchoDePantalla {
    if (anchoDePantalla == null) {
      throw Exception(
          "Config no ha sido inicializado. Llama a init(context) primero.");
    }
    return anchoDePantalla!;
  }

  static double get obtenerAltoDePantalla {
    if (altoDePantalla == null) {
      throw Exception(
          "Config no ha sido inicializado. Llama a init(context) primero.");
    }
    return altoDePantalla!;
  }

  // Espacios predefinidos
  static const espacioPequeno = SizedBox(height: 25); // Espacio fijo
  static SizedBox get espacioMediano => SizedBox(
        height: altoDePantalla != null ? altoDePantalla! * 0.05 : 0,
      );
  static SizedBox get espacioGrande => SizedBox(
        height: altoDePantalla != null ? altoDePantalla! * 0.08 : 0,
      );

  // Estilos de bordes para entradas de texto
  static const bordeRedondeado = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  );

  static const bordeEnfocado = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
  );
}
