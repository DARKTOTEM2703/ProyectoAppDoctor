import 'package:appdoctor/components/boton.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
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
            icon: Icon(
              isFavourite ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                isFavourite = !isFavourite;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Asegúrate de que el contenido sea desplazable si es necesario
          child: Column(
            children: <Widget>[
              // aquí construimos la tarjeta del doctor
              InformacionDoctor(),
              DetailBody(), // Asegúrate de incluir el cuerpo del detalle
              Padding(
                padding: const EdgeInsets.all(20),
                child: Boton(
                    width: double.infinity,
                    tittle: 'Libro de citas',
                    onPressed: () {},
                    disabled: false),
              ),
            ],
          ),
        ),
      ),
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
    return SizedBox(
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
              color: Colors.black,
            ),
          ),
          Config.espacioPequeno,
          SizedBox(
            width: Config.anchoDePantalla! * 0.75,
            child: const Text(
              'Especialista en medicina, egresado de la UADY, con más de 10 años de experiencia en el campo de la dermatología.',
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
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), //Aqui pongo el padding de 20
      margin: const EdgeInsets.only(bottom: 30), //Aqui pongo el margen de 30
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //CrossAxisAlignment.stretch asegura que los elementos se expandan horizontalmente
        children: <Widget>[
          Config.espacioPequeno,
          DoctorInfo(),
          Config.espacioMediano,
          const Text(
            'Acerca del Doctor',
            style: TextStyle(
              fontSize: 20, // aqui ponemos el tamaño de la letra
              fontWeight: FontWeight
                  .bold, //Aqui pongo el grosor de la letra en este caso en negrita
              color: Colors
                  .black, //Aqui pongo el color que quiero que lleve el texto
            ),
          ),
          Config
              .espacioPequeno, //Aqui extraigo la clase espacioPequeno desde config.dart
          Text(
            'Dr. Juan Pérez es un médico especialista en dermatología con más de 10 años de experiencia en el campo. Ha trabajado en varios hospitales y ha tratado a más de 100 pacientes con éxito. Es conocido por su habilidad para tratar enfermedades de la piel y su enfoque amigable con los pacientes. El Dr. Juan Pérez es un médico especialista en dermatología con más de 10 años de experiencia en el campo. Ha trabajado en varios hospitales y ha tratado a más de 100 pacientes con éxito. Es conocido por su habilidad para tratar enfermedades de la piel y su enfoque amigable con los pacientes.',
            style: TextStyle(
              height: 1.5, //Aqui ponemos el espaciado entre lineas
              fontWeight: FontWeight.w500, // aqui ponemos el grosor de la letra
            ),
            softWrap:
                true, //Aqui ponemos que se ajuste al tamaño del contenedor
            textAlign:
                TextAlign.justify, //Aqui ponemos que se justifique el texto
          ),
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
        InfoCard(
          label: 'Pacientes',
          value: '109',
        ),
        SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiencia',
          value: '10 años',
        ),
        SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Calificación',
          value: '4.5',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});

  final String label; // etiqueta
  final String value; // valor de la etiqueta

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Expanded(
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
              label,
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
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
