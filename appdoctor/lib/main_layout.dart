import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout(
      {super.key}); // Llamar al constructor de la clase padre correctamente
  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
//Delacamos la variable currentPage para almacenar la página actual
  int currentPage = 0;
  final PageController _page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: (value) {
          setState(() {
            //Aqui actualizamos la página actual
            currentPage = value;
          });
        },
      ),
    );
  }
}
