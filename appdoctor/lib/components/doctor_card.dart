import 'package:appdoctor/models/doctor_model.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

//

class TarjetaDoctor extends StatelessWidget {
  const TarjetaDoctor({
    super.key,
    required this.route,
    this.doctor,
  });
  final String route;
  final Doctor? doctor;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    
    // Datos por defecto si no hay doctor
    final doctorName = doctor?.doctorName ?? 'Dr. Roberto Gomez';
    final specialty = doctor?.category ?? 'Dermatología';
    final patients = doctor?.patients ?? 0;
    final experience = doctor?.experience ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.anchoDePantalla! * 0.33,
                child: Image.asset(
                  'assets/Doctor_2.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(doctorName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(specialty, style: const TextStyle(fontSize: 16)),
                      const Spacer(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Icon(
                              Icons.star_border,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            const Spacer(flex: 1),
                            Text('$experience años'),
                            const Spacer(flex: 1),
                            const Text('Pacientes'),
                            const Spacer(flex: 1),
                            Text('($patients)'),
                            const Spacer(
                              flex: 7,
                            ),
                          ])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          //esto redirige a la pantalla de detalles del doctor
          Navigator.of(context).pushNamed(route, arguments: doctor);
        },
      ),
    );
  }
}
