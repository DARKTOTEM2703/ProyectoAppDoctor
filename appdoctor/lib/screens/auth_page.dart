import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:appdoctor/components/login_forms.dart';
import 'package:appdoctor/utils/text.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  /// Manejar login exitoso
  void _handleLoginSuccess(Map<String, dynamic> response) {
    // Aquí puedes guardar el token en SharedPreferences o secure_storage
    print('Token: ${response['access_token']}');
    print('Usuario: ${response['user']}');

    // Navegar a la pantalla principal después de login exitoso
    Navigator.of(context).pushReplacementNamed('main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      APPText.obtenerTexto('es', 'welcome'),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.espacioPequeno,
                    Text(
                      APPText.obtenerTexto('es', 'signIn'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Config.espacioPequeno,
                    // Formulario de login conectado con Laravel
                    Formulariodeiniciodesecion(
                      onLoginSuccess: _handleLoginSuccess,
                    ),
                    Config.espacioPequeno,
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implementar recuperación de contraseña
                        },
                        child: Text(
                          APPText.obtenerTexto('es', 'forgot-password'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
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
                        SocialButton(social: 'Google'),
                      ],
                    ),
                    Config.espacioPequeno,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          APPText.obtenerTexto('es', 'singUp_text'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade500),
                        ),
                        Text(
                          'inicia sesion',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
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
