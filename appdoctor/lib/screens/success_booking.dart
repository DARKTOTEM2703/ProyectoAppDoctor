import 'package:appdoctor/components/boton.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              //Este archivo success se bajo de la pagina de lottie
              //Se descargo en formato json y se asigan en la carpeta assets
              child: Lottie.asset('assets/success.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                '¡Cita reservada con éxito!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Boton(
                width: double.infinity,
                tittle: 'Volver al inicio',
                onPressed: () => Navigator.of(context).pushNamed('main'),
                disabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
