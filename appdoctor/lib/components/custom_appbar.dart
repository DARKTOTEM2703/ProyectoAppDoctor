import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

// Define una barra de aplicaciones personalizada que es un StatefulWidget
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  // Constructor que acepta un título opcional para la aplicación
  const CustomAppBar(
      {super.key, this.appTitle, this.route, this.icon, this.actions});

  // Ruta opcional para la navegación
  final String? route;

  // Icono opcional para la barra de aplicaciones
  final Icon? icon;

  // Acciones opcionales para la barra de aplicaciones
  final List<Widget>? actions;

  // Define el tamaño preferido de la barra de aplicaciones
  @override
  Size get preferredSize => const Size.fromHeight(60);

  // Título opcional de la aplicación
  final String? appTitle;

  // Crea el estado asociado a este widget
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

// Estado asociado a CustomAppBar
class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    // Construye la barra de aplicaciones
    return AppBar(
      automaticallyImplyLeading: true, // Muestra el botón de retroceso
      backgroundColor:
          Colors.white, // Color de fondo de la barra de aplicaciones
      elevation: 0, // Sin elevación
      title: Text(widget.appTitle!, // Título de la barra de aplicaciones
          style: const TextStyle(
              color: Colors.black, // Color del texto
              fontSize: 20, // Tamaño de la fuente
              fontWeight: FontWeight.bold) // Peso de la fuente
          ),
      //La sintaxis !=null? significa que si el valor es
      //diferente de nulo entonces se muestra el icono
      leading: widget.icon != null
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Config.colorprimario,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  if (widget.route != null) {
                    Navigator.pushNamed(context, widget.route!);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: widget.icon!,
                iconSize: 16,
                color: Colors.white,
              ),
            )
          : null,
      //si la accion es diferente de nulo entonces se muestra
      actions: widget.actions,
    ); // Título de la barra de aplicaciones
  }
}
