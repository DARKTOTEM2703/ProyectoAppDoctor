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
      ),
    );
  }
}
