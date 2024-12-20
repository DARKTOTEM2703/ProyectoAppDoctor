import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
// Importa el paquete de material de flutter

class AppointmentPage extends StatefulWidget {
  //Stateful widget sirve para crear widgets que pueden cambiar de estado
  const AppointmentPage(
      {super.key}); // Llamar al constructor de la clase padre correctamente
  @override // Anulación de la función createState
  State<AppointmentPage> createState() =>
      _AppointmentPageState(); // Devuelve el estado de la página de inicio
}

enum FilterStatus {
  upcoming,
  complete,
  cancel
} // Enumeración de los estados del filtro

class _AppointmentPageState extends State<AppointmentPage> {
  // Estado de la página de inicio
  FilterStatus estado = FilterStatus.upcoming; // Estado del filtro
  Alignment _aleniacion = Alignment.centerLeft; // Alineación de los elementos
  List<dynamic> horarios = [
    {
      "doctor_name": "Dr. Juan Perez",
      "doctor_profile": "assets/doctor_1.png",
      "category": "Cardiologia",
      "estado": FilterStatus.upcoming,
    },
    {
      "doctor_name": "Dr. Roberto Gomez",
      "doctor_profile": "assets/Doctor_2.jpg",
      "category": "Cardiologia",
      "estado": FilterStatus.complete,
    },
    {
      "doctor_name": "Dr. Alfonso Garcia",
      "doctor_profile": "assets/doctor_3.jpg",
      "category": "Cardiologia",
      "estado": FilterStatus.cancel,
    },
  ]; // Lista de horarios
  @override
  Widget build(BuildContext context) {
    // Construcción de la página de inicio
    List<dynamic> horariosFiltrados = horarios.where((var horarios) {
      //   switch (horarios['estado']) {
      //     case 'upcoming':
      //       horarios['estado'] = FilterStatus.upcoming;
      //       break;
      //     case 'complete':
      //       horarios['estado'] = FilterStatus.complete;
      //       break;
      //     case 'cancel':
      //       horarios['estado'] = FilterStatus.cancel;
      //       break;
      //   }
      return horarios['estado'] == estado;
    }).toList(); // Lista de horarios filtrados
    return SafeArea(
      child: Padding(
        // Padding es un widget que permite agregar relleno a un widget hijo
        padding: const EdgeInsets.only(
            left: 20, top: 20, right: 20), // Padding de la página de inicio
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'horarios de citas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Config.espacioPequeno,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filter in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filter == FilterStatus.upcoming) {
                                  estado = FilterStatus.upcoming;
                                  _aleniacion = Alignment.centerLeft;
                                } else if (filter == FilterStatus.complete) {
                                  estado = FilterStatus.complete;
                                  _aleniacion = Alignment.center;
                                } else if (filter == FilterStatus.cancel) {
                                  estado = FilterStatus.cancel;
                                  _aleniacion = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(
                                filter == FilterStatus.upcoming
                                    ? 'Próximas'
                                    : filter == FilterStatus.complete
                                        ? 'Completadas'
                                        : 'Canceladas',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _aleniacion,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.colorprimario,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        estado == FilterStatus.upcoming
                            ? 'Próximas'
                            : estado == FilterStatus.complete
                                ? 'Completadas'
                                : 'Canceladas',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.espacioPequeno,
            Expanded(
              child: ListView.builder(
                itemCount: horariosFiltrados.length,
                itemBuilder: ((context, index) {
                  var horario = horariosFiltrados[index];
                  bool isLastElements = horariosFiltrados.length == index + 1;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: !isLastElements
                        ? const EdgeInsets.only(bottom: 20)
                        : const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(horario['doctor_profile']),
                              ),
                              Config.espacioPequeno,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    horario['doctor_name'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    horario['category'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _EstadoHorario(),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(
                                          color: Config.colorprimario),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // SizedBox es un widget que permite agregar un espacio en blanco
                                /// Un widget que crea un botón expandido con un borde y un color de fondo personalizado
                                /// y una etiqueta de texto 'Reagendar' en color blanco.
                                ///
                                /// Actualmente, el botón no tiene ninguna acción asignada a su callback `onPressed`.
                                ///
                                /// - El color de fondo del botón se establece en `Config.colorprimario`.
                                /// - La etiqueta de texto está estilizada con color blanco.
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Config.colorprimario,
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'Reagendar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ])
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
          // Column es un widget que organiza a sus hijos en una columna
        ),
      ),
    ); // Devuelve el centro de la página de inicio
  }
}

class _EstadoHorario extends StatefulWidget {
  @override
  _EstadoHorarioState createState() => _EstadoHorarioState();
}

class _EstadoHorarioState extends State<_EstadoHorario> {
  // Estado del horario

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // BoxDecoration es una clase que permite decorar un contenedor
        color: Colors.grey.shade700, // Color de fondo
        borderRadius: BorderRadius.circular(50), // Bordes redondeados
      ),
      width: double.infinity, // Ancho del contenedor
      padding: const EdgeInsets.all(20), // Padding de 20
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        // Row es un widget que organiza a sus hijos en una fila horizontal
        children: const <Widget>[
          Icon(
            Icons.calendar_today, // Icono de calendario
            color: Config.colorprimario, // Color del icono
            size: 15, // Tamaño del icono
          ),
          SizedBox(
            width: 10, // Espacio de 10
          ), // SizedBox es un widget que permite agregar un espacio en blanco
          Text(
            'Lunes 12 de Julio 2024', // Texto del día
            style: TextStyle(
              color: Config.colorprimario, // Color del texto
            ),
          ),
          SizedBox(
            width: 20, // Espacio de 20
          ),
          Icon(
            Icons.access_alarm, // Icono de alarma
            color: Config.colorprimario, // Color del icono
            size: 17, // Tamaño del icono
          ),
          SizedBox(
            width: 5, // Espacio de 5
          ),
          Flexible(
            child: Text(
              '2:00 PM', // Texto de la hora
              style: TextStyle(
                color: Config.colorprimario, // Color del texto
              ),
            ),
          ),
        ],
      ),
    );
  }
}
