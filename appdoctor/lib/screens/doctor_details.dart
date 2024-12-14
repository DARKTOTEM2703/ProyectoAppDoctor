import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
    );
  }
}
