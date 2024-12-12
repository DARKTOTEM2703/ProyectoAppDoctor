import 'package:flutter/material.dart';

// Clase que representa el horario de la cita
class Horario extends StatefulWidget {
  // Stateful widget sirve para crear widgets que pueden cambiar de estado
  const Horario(
      {super.key}); // Llamar al constructor de la clase padre correctamente

  @override // Anulación de la función createState
  State<Horario> createState() =>
      _EstadoHorario(); // Devuelve el estado del horario
}

// Clase que maneja el estado del horario
class _EstadoHorario extends State<Horario> {
  // Estado del horario

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // BoxDecoration es una clase que permite decorar un contenedor
        color: Colors.grey, // Color de fondo
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
      width: double.infinity, // Ancho del contenedor
      padding: const EdgeInsets.all(20), // Padding de 20
      child: Row(
        // Row es un widget que organiza a sus hijos en una fila horizontal
        children: const <Widget>[
          Icon(
            Icons.calendar_today, // Icono de calendario
            color: Colors.white, // Color del icono
            size: 15, // Tamaño del icono
          ),
          SizedBox(
            width: 10, // Espacio de 10
          ), // SizedBox es un widget que permite agregar un espacio en blanco
          Text(
            'Lunes 12 de Julio 2024', // Texto del día
            style: TextStyle(
              color: Colors.white, // Color del texto
            ),
          ),
          SizedBox(
            width: 20, // Espacio de 20
          ),
          Icon(
            Icons.access_alarm, // Icono de alarma
            color: Colors.white, // Color del icono
            size: 17, // Tamaño del icono
          ),
          SizedBox(
            width: 5, // Espacio de 5
          ),
          Flexible(
            child: Text(
              '2:00 PM', // Texto de la hora
              style: TextStyle(
                color: Colors.white, // Color del texto
              ),
            ),
          ),
        ],
      ),
    );
  }
}
