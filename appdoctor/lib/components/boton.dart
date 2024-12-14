import 'package:flutter/material.dart';

import '../utils/config.dart';

class Boton extends StatelessWidget {
  final String tittle; // Título del botón
  final Function() onPressed; // Función que se ejecuta al presionar el botón
  final bool disabled; // Estado del botón

  const Boton({
    super.key, // Llave del widget
    required this.tittle, // Título del botón
    required this.onPressed, // Función que se ejecuta al presionar el botón
    required this.disabled, // Estado del botón
  }); // Llama al constructor de la clase padre

  @override // Anulación del método build
  Widget build(BuildContext context) {
    // Método build
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth * 0.8, // Ajusta el ancho del botón
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Config.colorprimario, // Color de fondo
                foregroundColor: Colors.white, // Color del texto
              ), // Botón elevado
              onPressed: disabled
                  ? null
                  : onPressed, // aqui se deshabilita el botón si esta en estado deshabilitado
              child: Text(
                tittle, // Título del botón
                style: const TextStyle(
                  fontSize: 18, // Tamaño de la fuente de 16
                  fontWeight: FontWeight.bold, // Fuente en negrita
                ), // Texto del botón
              ),
            ),
          );
        },
      ),
    );
  }
}
