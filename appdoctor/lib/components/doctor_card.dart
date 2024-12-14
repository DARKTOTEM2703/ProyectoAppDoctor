import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

//

class TarjetaDoctor extends StatelessWidget {
  const TarjetaDoctor({
    super.key,
    required this.route,
  });
  final String route;

  @override
  Widget build(BuildContext context) {
    Config.init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 150,
      child: GestureDetector(
        child: Card(
          elevation: 5,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: Config.anchoDePantalla! * 0.33,
                child: Image.asset(
                  'assets/Doctor_2.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text('Dr. Roberto Gomez',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Dermatologo', style: TextStyle(fontSize: 16)),
                      Spacer(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.star_border,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            Spacer(flex: 1),
                            Text('4.5'),
                            Spacer(flex: 1),
                            Text('Reseñas'),
                            Spacer(flex: 1),
                            Text('(20)'),
                            Spacer(
                              flex: 7,
                            ),
                          ])
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          //esto redirige a la pantalla de detalles del doctor
          Navigator.of(context).pushNamed(route);
        },
      ),
    );
  }
}
