//Establecemos constantes para la configuración de la aplicación
import 'package:flutter/material.dart'; //Importamos el paquete material

class Config {
  static MediaQueryData? mediaQueryData; //Datos de la consulta de medios
  static double? anchodepantalla; //Ancho de la pantalla
  static double? altodepantalla; //Altura de la pantalla

  static void init(BuildContext context) {
    mediaQueryData =
        MediaQuery.of(context); //Obtenemos los datos de la consulta de medios
    anchodepantalla =
        mediaQueryData!.size.width; //Obtenemos el ancho de la pantalla
    altodepantalla =
        mediaQueryData!.size.height; //Obtenemos la altura de la pantalla
  }

  static get anchodePantalla {
    return anchodepantalla!; //Retornamos el ancho de la pantalla
  }

  static get altodePantalla {
    return altodepantalla!; //Retornamos la altura de la pantalla
  }
  //definimos el espacio de la altura de la pantalla
  // ignore: constant_identifier_names
  static const espacioPequeño = SizedBox(height: 25,);
  static final espaciomediano = SizedBox(height: altodepantalla != null ? altodepantalla! * 0.05 : 0);
  static final espaciogrande = SizedBox(height: altodepantalla != null ? altodepantalla! * 0.08 : 0);

    //forma del texto bordes redondeados
    static const OutlinedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
        );

    static const focusedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        borderSide: BorderSide(color: Colors.blue, width: 2.0)
        );

}
