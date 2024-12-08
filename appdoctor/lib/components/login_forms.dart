import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

class Formulariodeiniciodesecion extends StatefulWidget {
  const Formulariodeiniciodesecion({super.key});

  @override
  State<Formulariodeiniciodesecion> createState() =>
      _Estadodelosformulariosdeiniciodesesion();
}

class _Estadodelosformulariosdeiniciodesesion
    extends State<Formulariodeiniciodesecion> {
  final _llavedelformulario = GlobalKey<FormState>();
  final _controladordecorreo = TextEditingController();
  final _controladordecontrasena = TextEditingController();
  bool mostrarcontrasena =
      false; // Variable de estado para mostrar/ocultar la contraseña

  @override
  Widget build(BuildContext context) {
    return Form(
      // Formulario de inicio de sesión
      child: Column(
        // Columna de elementos
        mainAxisAlignment:
            MainAxisAlignment.start, // Alineación principal en el inicio
        children: <Widget>[
          // Lista de widgets
          TextFormField(
            // Campo de texto para el correo
            controller: _controladordecorreo, // Controlador del campo de texto
            keyboardType: TextInputType.emailAddress, // Tipo de teclado
            cursorColor: Config.colorprimario, // Color del cursor
            decoration: InputDecoration(
              // Decoración del campo de texto
              labelText: 'Correo', // Etiqueta del campo de texto
              hintText: 'ejemplo@dominio.com', // Texto de ayuda del fondo
              prefixIcon: Icon(Icons.email), // Icono del prefijo del campo
            ),
          ),
          Config.espacioPequeno, // Espacio pequeño
          TextFormField(
            // Campo de texto para el correo
            controller:
                _controladordecontrasena, // Controlador del campo de texto
            keyboardType: TextInputType.visiblePassword, // Tipo de teclado
            cursorColor: Config.colorprimario, // Color del cursor
            obscureText: !mostrarcontrasena, // Utiliza la variable de estado
            decoration: InputDecoration(
              // Decoración del campo de texto
              labelText: 'Contraseña', // Etiqueta del campo de texto
              hintText: 'Contraseña', // Texto de ayuda del fondo
              prefixIcon: Icon(Icons.lock), // Icono del prefijo del campo
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    mostrarcontrasena =
                        !mostrarcontrasena; // Actualiza la variable de estado
                  });
                },
                icon: Icon(
                  mostrarcontrasena
                      ? Icons.visibility
                      : Icons.visibility_off, // Icono de visibilidad
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
