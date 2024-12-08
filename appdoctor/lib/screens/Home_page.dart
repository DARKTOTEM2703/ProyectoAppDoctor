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
    return Center(
      child: Text('home page'), // Texto de la página de inicio
    ); // Devuelve el centro de la página de inicio
  }
}
