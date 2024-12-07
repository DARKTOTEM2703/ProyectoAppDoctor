//ESTA CLASE CONTIENE LOS TEXTOS DE LA APLICACIÓN
class APPText {
  static final Map<String, Map<String, String>> texts = {
    'en': {
      'welcome':
          'Welcome to the Doctor App', // Bienvenido a la aplicación del Doctor
      'signIn': 'Sign In to continue', // Inicia sesión para continuar
      'registered_text': 'already have an account?', // ¿Ya tienes una cuenta?
      'register_text':
          'You can easily sign in up, and connect to the Doctors nearby you', // Puedes registrarte fácilmente y conectarte con los Doctores cercanos a ti
      'singUp_text': 'Don\'t have an account', // ¿No tienes una cuenta?
      'social-login':
          'Or continue with social account?', // O continuar con cuenta social?
      'forgot-password': 'Forgot Your Password?', // ¿Olvidaste tu contraseña?
    },
    'es': {
      'welcome': 'Bienvenido a la aplicación del Doctor',
      'signIn': 'Inicia sesión para continuar',
      'registered_text': '¿Ya tienes una cuenta?',
      'register_text':
          'Puedes registrarte fácilmente y conectarte con los Doctores cercanos a ti',
      'singUp_text': '¿No tienes una cuenta?',
      'social-login': 'O continuar con cuenta social?',
      'forgot-password': '¿Olvidaste tu contraseña?',
    },
    // Puedes agregar más idiomas aquí
  };

  static String getText(String languageCode, String key) {
    return texts[languageCode]?[key] ?? key;
  }
}
