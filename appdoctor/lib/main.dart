import 'package:appdoctor/components/booking_page.dart';
import 'package:appdoctor/main_layout.dart';
import 'package:appdoctor/screens/auth_page.dart'; // Corregido el nombre del archivo importado
import 'package:appdoctor/screens/register_page.dart';
import 'package:appdoctor/screens/profile_page.dart';
import 'package:appdoctor/screens/doctor_details.dart';
import 'package:appdoctor/screens/success_booking.dart';
import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final llaveDeNavegacion = GlobalKey<
      NavigatorState>(); // Llave global para el navegador sirve para navegar entre pantallas

  @override
  Widget build(BuildContext context) {
    //Aqui definimos el tema de la aplicación
    return MaterialApp(
      navigatorKey:
          llaveDeNavegacion, // Asignamos la llave global al navegador para poder navegar entre pantallas
      title: 'Flutter Doctor App', // Título de la aplicación
      debugShowCheckedModeBanner: false, // Ocultamos la cinta de depuración
      theme: ThemeData(
        /* Definimos el tema de la aplicación usando inputDecorationTheme asigandole
          la constante InputDecorationTheme que realiza la decoración de la entrada*/

        inputDecorationTheme: const InputDecorationTheme(
          // -----------TEMAS DE ENTRADA DE DECORACIÓN----------------

          /* Aqui definimos el color de enfoque usando la clase Config
        para obtener el color primario previamente configurado en config.dart*/
          focusColor: Config.colorprimario,
          //aqui asignamos el color de enfoque
          border: Config.bordeRedondeado,
          //aqui asignamos el borde redondeado
          focusedBorder: Config.bordeEnfocado,
          //aqui asignamos el borde enfocado
          errorBorder: Config.bordeError,
          //aqui asignamos el borde de error
          enabledBorder: Config.bordeRedondeado,
          /* enabledBorder sirve para cambiar el color del borde y
        usamos la clase Config para obtener el borde redondeado definido en config.dart*/
          floatingLabelStyle: TextStyle(color: Config.colorprimario),
          /* floatingLabelStyle sirve para cambiar el color del texto flotante de igual
          manera usando la clase Config usando el metodo "colorprimario" */
          prefixIconColor: Colors
              .black38, // prefixIconColor sirve para cambiar el color del icono de prefijo
        ),
        scaffoldBackgroundColor:
            Colors.white, // Color de fondo de la aplicación
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          /*bottomNavigationBarTheme sirve para cambiar
      el tema de la barra de navegación*/
          backgroundColor: //color de fondo
              Config.colorprimario, // Color de fondo de la barra de navegación
          selectedItemColor:
              Colors.white, // Color del ítem seleccionado de color blanco
          unselectedItemColor: Colors
              .grey.shade700, // Color del ítem no seleccionado de color gris
          showSelectedLabels: true, // Mostrar etiquetas seleccionadas
          showUnselectedLabels: false, // Mostrar etiquetas no seleccionadas
          elevation: 10, // Elevación de la barra de navegación
          type: BottomNavigationBarType
              .fixed, // Tipo de barra de navegación fija para que no se desplace
        ),
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const AuthPage(),
        'register': (context) => const RegisterPage(),
        'main': (context) =>
            const MainLayout(), // Asegúrate de que esta ruta esté definida
        'profile': (context) {
          // Obtener datos del usuario desde argumentos
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ProfilePage(userData: args ?? {});
        },
        'doc_details': (context) => const DoctorDetails(),
        'booking_page': (context) => BookingPage(),
        'success_booking': (context) => AppointmentBooked(),
      },
      //   home: const MyHomePage(title: 'Doctor App'), // Página de inicio
    );
  }
}
