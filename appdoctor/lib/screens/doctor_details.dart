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
        appTitle: 'Doctor Details',
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
          ],
        ));
  }
}
