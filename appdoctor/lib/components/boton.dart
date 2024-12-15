import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final String tittle; // Título del botón
  final Function() onPressed; // Función que se ejecuta al presionar el botón
  final bool disabled; // Estado del botón
  final double width; // Ancho del botón

  const Boton({
    super.key, // Llave del widget
    required this.tittle, // Título del botón
    required this.onPressed, // Función que se ejecuta al presionar el botón
    required this.disabled,
    required this.width, // Estado del botón
  }); // Llama al constructor de la clase padre

  @override // Anulación del método build
  Widget build(BuildContext context) {
    // Método build
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: width, // Ajusta el ancho del botón según la variable width
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 57, 224, 143), // Color de fondo
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
