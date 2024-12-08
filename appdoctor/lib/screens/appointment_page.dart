import 'package:flutter/material.dart'; // Importa el paquete de material de flutter

class AppointmentPage extends StatefulWidget {
  //Stateful widget sirve para crear widgets que pueden cambiar de estado
  const AppointmentPage(
      {super.key}); // Llamar al constructor de la clase padre correctamente
  @override // Anulación de la función createState
  State<AppointmentPage> createState() =>
      _AppointmentPageState(); // Devuelve el estado de la página de inicio
}

class _AppointmentPageState extends State<AppointmentPage> {
  // Estado de la página de inicio
  @override
  Widget build(BuildContext context) {
    // Construcción de la página de inicio
    return Center(
      child: Text('Appointment page'), // Texto de la página de inicio
    ); // Devuelve el centro de la página de inicio
  }
}
