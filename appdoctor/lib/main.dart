import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<
      NavigatorState>(); // Llave global para el navegador sirve para navegar entre pantallas

  @override
  Widget build(BuildContext context) {
    //Aqui definimos el tema de la aplicación
    return MaterialApp(
      navigatorKey:
          navigatorKey, // Asignamos la llave global al navegador para poder navegar entre pantallas
      title: 'Flutter Doctor App', // Título de la aplicación
      debugShowCheckedModeBanner: false, // Ocultamos la cinta de depuración
      theme: ThemeData(
        // Definimos el tema de la aplicación
        inputDecorationTheme:
            const InputDecorationTheme(), // Tema de decoración de entrada
        /* Aqui definimos el color de enfoque usando la clase Config
        para obtener el color primario previamente configurado en config.dart*/
        focusColor: Config.primaryColor,
      ),
      home: const MyHomePage(title: 'JOSUE GAMBOA'),
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
