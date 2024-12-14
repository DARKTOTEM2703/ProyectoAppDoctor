import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:appdoctor/components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({
    super.key,
  });

  @override
  State<DoctorDetails> createState() => _DoctorDetails();
}

class _DoctorDetails extends State<DoctorDetails> {
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Información del Doctor',
        icon: const Icon(Icons.arrow_back_ios),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                isFavourite ? Icons.favorite_rounded : Icons.favorite_outline,
                color: Colors.red,
              ))
        ],
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          //aqui construimos la tarjeta del doctor
          InformacionDoctor(),
        ],
      )),
    );
  }
}

class InformacionDoctor extends StatelessWidget {
  const InformacionDoctor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/Doctor_2.jpg'),
              backgroundColor: Colors.white,
            ),
            Config.espacioMediano,
            Text(
              'Dr. Juan Pérez',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Config.espacioPequeno,
            SizedBox(
              width: Config.anchoDePantalla! * 0.75,
              child: const Text(
                'Especialista en medicina, egresado de la  UADY, con más de 10 años de experiencia en el campo de la dermatologia.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            Config.espacioPequeno,
            SizedBox(
              width: Config.anchoDePantalla! * 0.75,
              child: const Text(
                'Hospital general de Mérida',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.espacioPequeno,
          DoctorInfo(),
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Config.colorprimario,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'pacientes',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '109',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Container();
  }
}
