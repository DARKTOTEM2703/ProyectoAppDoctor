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
          backgroundColor:
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
        //esta es la ruta de la aplicación es la pagina de autinticación (login and register)
        // Rutas de la aplicación
        '/': (context) =>
            const
      },
      home: const MyHomePage(title: 'Doctor App'), // Página de inicio
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Este es un texto de prueba para el body:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
