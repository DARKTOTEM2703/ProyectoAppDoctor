import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //Stateful widget sirve para crear widgets que pueden cambiar de estado
  const HomePage(
      {super.key}); // Llamar al constructor de la clase padre correctamente
  @override // Anulación de la función createState
  State<HomePage> createState() =>
      _HomePageState(); // Devuelve el estado de la página de inicio
}

class _HomePageState extends State<HomePage> {
  // Estado de la página de inicio
  @override
  Widget build(BuildContext context) {
    // Construcción de la página de inicio
    Config.init(context); // Inicializa la configuración de la aplicación
    return Scaffold(
      // Devuelve la estructura de la página de inicio
      body: Padding(
        // Padding es un widget que permite agregar relleno a un widget hijo
        padding: const EdgeInsets.symmetric(
            // edgeInsets.symmetric crea un padding simétrico
            horizontal: 15,
            vertical: 15
            // establece el relleno horizontal y vertical
            ),
        child: SafeArea(
          // SafeArea es un widget que permite evitar que los elementos se superpongan en el área segura
          child: Column(
            // Column es un widget que permite alinear los elementos en una columna
            mainAxisAlignment: MainAxisAlignment
                .start, //esto alinea los elementos en la parte superior
            crossAxisAlignment: CrossAxisAlignment
                .start, //esto alinea los elementos en la parte izquierda
            children: <Widget>[
              // Lista de widgets
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Alineación principal entre los elementos
                children: <Widget>[
                  // Lista de widgets
                  Text(
                    // Texto de bienvenida
                    'Amanda', // Nombre de usuario
                    style: TextStyle(
                      // Estilo del texto
                      fontSize: 24, // Tamaño de la fuente
                      fontWeight: FontWeight.bold, // Peso de la fuente
                    ),
                  ),
                  CircleAvatar(
                    // Avatar circular
                    radius: 30, // Radio del avatar
                    backgroundImage: AssetImage(
                        'assets/amanda.jpg'), // Imagen de fondo del avatar
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
