import 'package:flutter/material.dart'; // Importamos el paquete Material

class Config {
  /* Clase Config donde agregaremos los metodos para obtener las dimensiones de la pantalla 
  y los colores que se usaran en la misma asi aplicando la modularidad*/
  // Datos de la consulta de medios
  static MediaQueryData?
      mediaQueryData; //los mediaqeurydata sirven para obterner datos de la pantalla
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
  static const espacioMediano = SizedBox(height: 15); // Espacio fijo de 15
  static const espacioGrande = SizedBox(height: 30); // Espacio fijo de 30

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
  static const colorprimario = Colors
      .greenAccent; // aqui asignamos a la variable primaryColor el color verde

  // API Configuration - Linux SQLite Local Development
  // Para desarrollo local en Linux con SQLite (sin configuración de red)
  static const String apiBaseUrl = 'localhost:8000';
  static const String apiPrefix = '/api';
  
  // URL completa de la API
  static String get fullApiUrl => 'http://$apiBaseUrl$apiPrefix';
}
