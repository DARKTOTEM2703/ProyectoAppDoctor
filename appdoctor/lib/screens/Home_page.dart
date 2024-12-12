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
  List<Map<String, dynamic>> categorias = [
    {
      "icono": Icons.local_hospital_outlined,
      "nombre": "General",
    },
    {
      "icono": Icons.favorite_outline,
      "nombre": "Cardiologia",
    },
    {
      "icono": Icons.air_outlined,
      "nombre": "Respiratoria",
    },
    {
      "icono": Icons.healing_outlined,
      "nombre": "Dermatologia",
    },
    {
      "icono": Icons.pregnant_woman_outlined,
      "nombre": "Ginecologia",
    },
    {
      "icono": Icons
          .medical_services_outlined, // Cambiar a un icono de diente de Dart
      "nombre": "Dentista",
    },
  ];
  // Estado de la página de inicio
  @override
  Widget build(BuildContext context) {
    // Construcción de la página de inicio
    Config.init(context); // Inicializa la configuración de la aplicación
    return LayoutBuilder(
      builder: (context, constraints) {
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
              child: SingleChildScrollView(
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
                            fontSize: constraints.maxWidth *
                                0.06, // Tamaño de la fuente
                            fontWeight: FontWeight.bold, // Peso de la fuente
                          ),
                        ),
                        CircleAvatar(
                          // Avatar circular
                          radius:
                              constraints.maxWidth * 0.08, // Radio del avatar
                          backgroundImage: AssetImage(
                              'assets/amanda.jpg'), // Imagen de fondo del avatar
                        ),
                      ],
                    ),
                    Config.espacioMediano, // Espacio pequeño
                    //Aqui hare la lista de categorias
                    const Text(
                      'Categorias',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.espacioPequeno, // Espacio pequeño
                    //Aqui hare la lista de categorias
                    SizedBox(
                      height: constraints.maxHeight *
                          0.2, // Ajustar el tamaño del SizedBox
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            List<Widget>.generate(categorias.length, (index) {
                          return Card(
                            margin: const EdgeInsets.only(right: 20),
                            color: Config.colorprimario,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      categorias[index]["icono"],
                                      color: Colors.white,
                                      size: constraints.maxWidth * 0.05,
                                    ),
                                    Text(
                                      categorias[index]["nombre"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: constraints.maxWidth * 0.04,
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
