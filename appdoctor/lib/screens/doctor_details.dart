import 'package:appdoctor/components/boton.dart';
import 'package:appdoctor/models/doctor_model.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:appdoctor/components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  final Doctor? doctor;

  const DoctorDetails({
    super.key,
    this.doctor,
  });

  @override
  State<DoctorDetails> createState() => _DoctorDetails();
}

class _DoctorDetails extends State<DoctorDetails> {
  bool isFavourite = false;
  bool isBooked = false; // Nueva variable para el estado del botón

  @override
  Widget build(BuildContext context) {
    // Obtener el doctor del argumento si no fue proporcionado
    final doctor = ModalRoute.of(context)?.settings.arguments as Doctor? ?? widget.doctor;

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
              InformacionDoctor(doctor: doctor),
              DetailBody(doctor: doctor), // Asegúrate de incluir el cuerpo del detalle
              Padding(
                padding: const EdgeInsets.all(
                    20), // EdgeInsets.all(20) es un padding de 20
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isBooked = !isBooked;
                      });
                    },
                    splashColor: Colors.black87, // Color más oscuro al pulsar
                    child: Boton(
                      width: double.infinity,
                      tittle: 'Libro de citas',
                      onPressed: () {
                        Navigator.of(context).pushNamed('booking_page', arguments: doctor);
                        setState(() {
                          isBooked = !isBooked;
                        });
                      },
                      disabled: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InformacionDoctor extends StatelessWidget {
  final Doctor? doctor;

  const InformacionDoctor({
    super.key,
    this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    
    final doctorName = doctor?.doctorName ?? 'Dr. Juan Pérez';
    final category = doctor?.category ?? 'Dermatología';
    final bioData = doctor?.bioData ?? 'Especialista en medicina con más de 10 años de experiencia.';

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
            doctorName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Config.espacioPequeno,
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Config.espacioPequeno,
          SizedBox(
            width: Config.anchoDePantalla! * 0.75,
            child: Text(
              bioData,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
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
  final Doctor? doctor;

  const DetailBody({
    super.key,
    this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    final bioData = doctor?.bioData ?? 'Doctor especializado en medicina general con experiencia en atención primaria.';

    return Container(
      padding: const EdgeInsets.all(20), //Aqui pongo el padding de 20
      margin: const EdgeInsets.only(bottom: 30), //Aqui pongo el margen de 30
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, //CrossAxisAlignment.stretch asegura que los elementos se expandan horizontalmente
        children: <Widget>[
          Config.espacioPequeno,
          DoctorInfo(doctor: doctor),
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
            bioData,
            style: const TextStyle(
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
  final Doctor? doctor;

  const DoctorInfo({
    super.key,
    this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    
    final patients = doctor?.patients?.toString() ?? '109';
    final experience = doctor?.experience?.toString() ?? '10';

    return Row(
      children: <Widget>[
        InfoCard(
          label: 'Pacientes',
          value: patients,
        ),
        const SizedBox(
          width: 15,
        ),
        InfoCard(
          label: 'Experiencia',
          value: '$experience años',
        ),
        const SizedBox(
          width: 15,
        ),
        const InfoCard(
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
