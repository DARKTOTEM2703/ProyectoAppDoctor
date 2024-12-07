import 'package:flutter/material.dart';

// Definición de un StatefulWidget llamado AuthPage que muestra la página de autenticación
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}): super(key: key); // Llamar al constructor de la clase padre correctamente
  @override
  State<AuthPage> createState() =>_AuthPageState(); // Crea el estado asociado a este widget
}

// Clase que maneja el estado del widget AuthPage
class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Estructura de la página
      body: Center(
        child: Text('Página de autenticación'),
      ),
    );
  }
}
