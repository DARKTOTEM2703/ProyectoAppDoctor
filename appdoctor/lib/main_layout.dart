import 'package:appdoctor/screens/Home_page.dart';
import 'package:appdoctor/screens/appointment_page.dart';
import 'package:appdoctor/screens/profile_page.dart';
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
        // PageView es un widget que permite desplazarse entre páginas
        controller:
            _page, //Asignamos el controlador lo que hace es que se pueda cambiar de página
        onPageChanged: (value) {
          //Cuando cambie de página
          setState(() {
            //Actualizamos la página actual
            currentPage =
                value; //Al tenerlo de esta manera actualiza la pagina principal
          });
        },
        children: const [
          //children es un método que permite agregar widgets los cuales se mostrarán en la pantalla
          //Agregamos las páginas que queremos mostrar
          HomePage(),
          AppointmentPage(),
          ProfilePage(userData: {}),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //BottomNavigationBar es un widget que permite agregar un menú de navegación en la parte inferior
        currentIndex: currentPage, //Indicamos la página actual
        onTap: (pagina) {
          //Cuando se seleccione una página
          setState(() {
            //Actualizamos la página actual
            currentPage = pagina; //Cambiamos a la página seleccionada
            _page.animateToPage(pagina,
                duration: const Duration(
                    milliseconds: 500), //Duración de la animación
                curve: Curves.easeInOut);
            //Curves.easeInOut es un tipo de animación que permite que la transición sea más suave
          });
        },
        items: const <BottomNavigationBarItem>[
          // items es un método que permite agregar los elementos del menú de navegación
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services), // Icono de la página
            label: 'Inicio', // Texto de la página
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), // Icono de la página
            label: 'Citas', // Texto de la página
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icono de la página
            label: 'Perfil', // Texto de la página
          ),
        ],
      ),
    );
  }
}
