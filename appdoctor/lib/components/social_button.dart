import 'package:appdoctor/utils/config.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.social});
  final String social;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: SizedBox(
        width: Config.anchoDePantalla,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/$social.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Continua con $social',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
