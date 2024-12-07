import 'package:appdoctor/utils/config.dart';
import 'package:appdoctor/utils/text.dart';
import 'package:flutter/material.dart';

// Definición de un StatefulWidget llamado AuthPage que muestra la página de autenticación
class AuthPage extends StatefulWidget {
  const AuthPage({super.key}); // Llamar al constructor de la clase padre correctamente
  @override
  State<AuthPage> createState() =>_AuthPageState(); // Crea el estado asociado a este widget
}

// Clase que maneja el estado del widget AuthPage
class _AuthPageState extends State<AuthPage> {
    Config.init(context); // Inicializa las variables de Config con el contexto
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold es un widget que implementa la estructura básica de la página
      // Estructura de la págin
      body: Padding(
        //el padign sirve para agregar espacio entre los bordes del widget y su contenido
        padding: const EdgeInsets.symmetric(
          // Padding simétrico
          horizontal: 15, // Espacio horizontal de 15
          vertical: 15, // Espacio vertical de 15),
        ),
        child: SafeArea(
          child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Alineación principal en el inicio
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alineación cruzada al inicio
              children: <Widget>[
                Text(
                  APPText.obtenerTexto(//se llama al metodo obtenerTexto de la clase APPText
                      'es', 'welcome'), // Obtiene el texto de bienvenida
                  style: const TextStyle(
                    fontSize: 36, // Tamaño de la fuente de 30
                    fontWeight: FontWeight.bold, // Fuente en negrita
                  ),
                ),
                  Config.espacioPequeno, // Espacio pequeño
                  Text(
                    APPText.obtenerTexto('es', 'signIn'), // Obtiene el texto de inicio de sesión
                    style: const TextStyle(
                      fontSize: 16, // Tamaño de la fuente de 24
                      fontWeight: FontWeight.bold, // Fuente en negrita
                    ),
                  )
              ], // Lista de widgets hijos
              ),
        ),
      ),
    );
  }
}
