import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:appdoctor/components/login_forms.dart';
import 'package:appdoctor/components/boton.dart';
import 'package:appdoctor/utils/text.dart';
import 'package:appdoctor/components/social_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                // Añadido Center para centrar los elementos
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centrar verticalmente
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centrar horizontalmente
                  children: <Widget>[
                    Text(
                      APPText.obtenerTexto(
                          'es', 'welcome'), // Obtiene el texto de bienvenida
                      style: const TextStyle(
                        fontSize: 36, // Tamaño de la fuente de 30
                        fontWeight: FontWeight.bold, // Fuente en negrita
                      ), // Estilo del texto
                    ), // Texto de bienvenida
                    Config.espacioPequeno, // Espacio pequeño
                    Text(
                      APPText.obtenerTexto('es',
                          'signIn'), // Obtiene el texto de inicio de sesión
                      style: const TextStyle(
                        fontSize: 16, // Tamaño de la fuente de 24
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
                    Boton(
                      tittle: 'Iniciar sesión',
                      onPressed: () {},
                      disabled: false,
                    ),
                    Config
                        .espacioPequeno, // Añadir un Spacer para empujar el contenido hacia abajo
                    Center(
                      child: Text(
                        APPText.obtenerTexto('es', 'social-login'),
                        style: TextStyle(
                          fontSize: 16, // Tamaño de la fuente de 16
                          fontWeight: FontWeight.bold, // Fuente en negrita
                          color:
                              Colors.grey.shade500, // Establece el color negro
                        ),
                      ),
                    ),
                    Config.espacioPequeno,
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centrar horizontalmente
                      children: const <Widget>[
                        SocialButton(social: 'google-sing-in-button'),
                      ],
                    ),
                    // ...existing code...
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
