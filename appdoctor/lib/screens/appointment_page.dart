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
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Appointment page'), // Texto de la página de inicio
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción de autenticación
              },
              child: Text('Autenticarse'),
            ),
          ],
        ),
      ),
    ); // Devuelve el centro de la página de inicio
  }
}
