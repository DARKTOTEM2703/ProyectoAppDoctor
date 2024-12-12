import 'package:appdoctor/components/Horario.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

// Clase principal que representa la tarjeta de cita
class TarjetaCita extends StatefulWidget {
  // Stateful widget sirve para crear widgets que pueden cambiar de estado
  const TarjetaCita(
      {super.key}); // Llamar al constructor de la clase padre correctamente

  @override // Anulación de la función createState
  State<TarjetaCita> createState() =>
      _EstadoTarjetaCita(); // Devuelve el estado de la tarjeta de cita
}

// Clase que maneja el estado de la tarjeta de cita
class _EstadoTarjetaCita extends State<TarjetaCita> {
  // Estado de la tarjeta de cita

  @override
  Widget build(BuildContext context) {
    // Construcción de la tarjeta de cita
    Config.init(context); // Inicializa la configuración de la aplicación
    bool isDarkMode = Theme.of(context).brightness ==
        Brightness.dark; // Verifica si el modo oscuro está activado

    return Container(
      width: double.infinity, // Ancho de la tarjeta de cita
      decoration: BoxDecoration(
        // BoxDecoration es una clase que permite decorar un contenedor
        color: isDarkMode
            ? Colors.grey[800]
            : Config.colorprimario, // Color de fondo según el modo
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      child: Material(
        color: Colors.transparent, // Color transparente para el material
        child: Padding(
          padding: const EdgeInsets.all(15), // Padding de 15
          child: Column(
            // Column es un widget que organiza a sus hijos en una columna vertical
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                // LayoutBuilder permite construir un widget basado en las restricciones de su padre
                return Row(
                  children: [
                    CircleAvatar(
                      // Avatar circular
                      radius: constraints.maxWidth * 0.08, // Radio del avatar
                      backgroundImage: const AssetImage(
                          'assets/doctor_1.png'), // Imagen de fondo del avatar
                    ),
                    const SizedBox(
                      width: 10, // Espacio de 10
                    ), // SizedBox es un widget que permite agregar un espacio en blanco
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Dr. Juan Perez', // Texto del doctor
                          style: TextStyle(
                            // Estilo del texto
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black, // Color según el modo
                          ),
                        ),
                        const SizedBox(
                          height: 5, // Espacio de 5
                        ), // SizedBox es un widget que permite agregar un espacio en blanco
                        Text(
                          'Cardiologo', // Especialidad del doctor
                          style: TextStyle(
                            // Estilo del texto
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.black, // Color según el modo
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              Config.espacioPequeno, // Espacio pequeño
              const Horario(), // Horario de la cita
              Config.espacioPequeno, // Espacio pequeño
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Alineación de los botones
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Color del botón
                      ),
                      child: const Text(
                        'Cancelar Cita', // Texto del botón
                        style:
                            TextStyle(color: Colors.white), // Estilo del texto
                      ),
                      onPressed: () {}, // Acción al presionar el botón
                    ),
                  ),
                  const SizedBox(
                    width: 10, // Espacio entre los botones
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Color del botón
                      ),
                      child: const Text(
                        'Completar Cita', // Texto del botón
                        style:
                            TextStyle(color: Colors.white), // Estilo del texto
                      ),
                      onPressed: () {}, // Acción al presionar el botón
                    ),
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
