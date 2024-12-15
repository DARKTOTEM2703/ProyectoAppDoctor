import 'package:appdoctor/components/boton.dart';
import 'package:appdoctor/components/login_forms.dart';
import 'package:appdoctor/utils/text.dart';
import 'package:flutter/material.dart';
import '../utils/config.dart'; // Importa el archivo config.dart

// Definición de un StatefulWidget llamado AuthPage que muestra la página de autenticación
class AuthPage extends StatefulWidget {
  // Clase AuthPage que extiende de StatefulWidget
  const AuthPage({Key? key})
      : super(
            key: key); // Llamar al constructor de la clase padre correctamente

  @override
  State<AuthPage> createState() =>
      _AuthPageState(); // Crea el estado asociado a este widget
}

// Clase que maneja el estado del widget AuthPage
class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    Config.init(
        context); // Inicializa las variables de Config para poderlas usar en la clase
    return Scaffold(
      // Scaffold es un widget que implementa la estructura básica de la página
      body: Padding(
        // El padding sirve para agregar espacio entre los bordes del widget y su contenido
        padding: const EdgeInsets.symmetric(
          horizontal: 15, // Espacio horizontal de 15
          vertical: 15, // Espacio vertical de 15
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .start, // Alineación principal en el inicio
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alineación cruzada al inicio
                children: <Widget>[
                  Text(
                    APPText.obtenerTexto(
                        'es', 'welcome'), // Obtiene el texto de bienvenida
                    style: const TextStyle(
                      fontSize: 36, // Tamaño de la fuente de 36
                      fontWeight: FontWeight.bold, // Fuente en negrita
                    ), // Estilo del texto
                  ), // Texto de bienvenida
                  Config.espacioPequeno, // Espacio pequeño
                  Text(
                    APPText.obtenerTexto(
                        'es', 'signIn'), // Obtiene el texto de inicio de sesión
                    style: const TextStyle(
                      fontSize: 16, // Tamaño de la fuente de 16
                      fontWeight: FontWeight.bold, // Fuente en negrita
                    ),
                  ), // Texto de inicio de sesión
                  Config.espacioPequeno, // Espacio pequeño
                  const Formulariodeiniciodesecion(), // Formulario de inicio de sesión
                  Config.espacioPequeno, // Espacio pequeño
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Acción al presionar el botón
                      },
                      child: Text(
                        APPText.obtenerTexto('es',
                            'forgot-password'), // Obtiene el texto de olvidó la contraseña
                        style: const TextStyle(
                          fontSize: 16, // Tamaño de la fuente de 16
                          fontWeight: FontWeight.bold, // Fuente en negrita
                          color: Colors.black, // Establece el color negro
                        ),
                      ),
                    ),
                  ),
                  Config.espacioPequeno,
                  Center(
                    child: Boton(
                      width: MediaQuery.of(context).size.width *
                          0.8, // Asigna un valor adecuado a width
                      tittle: 'Iniciar sesión',
                      onPressed: () {},
                      disabled: false,
                    ),
                  ),
                ], // Lista de widgets hijos
              ),
            ),
          ),
        ),
      ),
    );
  }
}
