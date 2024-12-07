import 'package:flutter/material.dart';

// Definición de un StatefulWidget llamado AuthPage que muestra la página de autenticación
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) // Constructor de la clase AuthPage
      : super(key: key); // el super llama al constructor de la clase padre
  @override
  State<AuthPage>() =>
      _AuthPageState(); // Crea el estado asociado a este widget
}

// Clase que maneja el estado del widget AuthPage
class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    // Construye la interfaz de usuario del widget
    return Scaffold(
      //Scaffold es un widget de Material que implementa el diseño visual de la estructura de la aplicación
      appBar: AppBar(
        // appBar es la barra superior de la aplicación
        title: Text('Auth Page'), // Título de la barra de la aplicación
      ),
      body: Center(
        child: Text('Página de autenticación'), // Texto centrado en la pantalla
      ),
    );
  }
}
