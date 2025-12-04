import 'package:appdoctor/components/appointment_card.dart';
import 'package:appdoctor/components/doctor_card.dart';
import 'package:appdoctor/models/doctor_model.dart';
import 'package:appdoctor/services/doctor_service.dart';
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

  late Future<List<Doctor>> doctorsFuture;

  @override
  void initState() {
    super.initState();
    doctorsFuture = DoctorService.getAllDoctors();
  }

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
          padding: EdgeInsets.symmetric(
            horizontal: constraints.maxWidth * 0.04,
            vertical: constraints.maxHeight * 0.02,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
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
                          fontSize: constraints.maxWidth *
                              0.05, // Tamaño de la fuente reducido
                          fontWeight: FontWeight.bold, // Peso de la fuente
                        ),
                      ),
                      CircleAvatar(
                        // Avatar circular
                        radius: constraints.maxWidth *
                            0.07, // Radio del avatar reducido
                        backgroundImage: AssetImage(
                            'assets/amanda.jpg'), // Imagen de fondo del avatar
                      ),
                    ],
                  ),
                  Config.espacioMediano, // Espacio mediano
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
                        0.15, // Ajustar el tamaño del SizedBox
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List<Widget>.generate(
                        categorias.length,
                        (index) {
                          return Container(
                            width: constraints.maxWidth *
                                0.35, // Ajustar el ancho del contenedor
                            margin: EdgeInsets.only(
                                right: constraints.maxWidth * 0.04),
                            child: Card(
                              color: Config.colorprimario,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: constraints.maxWidth * 0.03,
                                  vertical: constraints.maxHeight * 0.015,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      categorias[index]["icono"],
                                      color: Colors.white,
                                      size: constraints.maxWidth * 0.08,
                                    ),
                                    SizedBox(
                                        height: constraints.maxHeight * 0.008),
                                    Text(
                                      categorias[index]["nombre"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: constraints.maxWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Config.espacioPequeno, // Espacio pequeño
                  const Text(
                    'Citas de hoy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Config.espacioPequeno, // Espacio pequeño
                  Column(
                    // Column es un widget que permite alinear los elementos en una columna
                    mainAxisAlignment: MainAxisAlignment
                        .start, //esto alinea los elementos en la parte superior
                    crossAxisAlignment: CrossAxisAlignment
                        .start, //esto alinea los elementos en la parte izquierda
                    children: <Widget>[
                      // Lista de widgets
                      TarjetaCita(),
                      Config.espacioPequeno, // Espacio pequeño
                      const Text(
                        'Lista de doctores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.espacioPequeno, // Espacio pequeño
                      FutureBuilder<List<Doctor>>(
                        future: doctorsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No se encontraron doctores'),
                            );
                          } else {
                            final doctors = snapshot.data!;
                            return Column(
                              children: List.generate(doctors.length, (index) {
                                return TarjetaDoctor(
                                  doctor: doctors[index],
                                  route: 'doc_details',
                                );
                              }),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
