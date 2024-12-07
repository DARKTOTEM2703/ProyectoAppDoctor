//ESTA CLASE CONTIENE LOS TEXTOS DE LA APLICACIÓN
class APPText {
  //se declara la clase que contiene los textos de la aplicación
  static final Map<String, Map<String, String>> textos = {
    //metodo para agregar los textos en diferentes idiomas
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
      'welcome':
          'Bienvenido a la aplicación del Doctor', // Welcome to the Doctor App
      'signIn': 'Inicia sesión para continuar', // Sign In to continue
      'registered_text': '¿Ya tienes una cuenta?', // already have an account?
      'register_text':
          'Puedes registrarte fácilmente y conectarte con los Doctores cercanos a ti', // You can easily sign in up, and connect to the Doctors nearby you
      'singUp_text': '¿No tienes una cuenta?', // Don't have an account
      'social-login':
          'O continuar con cuenta social?', // Or continue with social account?
      'forgot-password': '¿Olvidaste tu contraseña?', // Forgot Your Password?
    },
    // Puedes agregar más idiomas aquí // You can add more languages here
  };
// Método para obtener el texto de la aplicación
  static String obtenerTexto(String lenguajesCodigo, String llave) {
    /*esto lo que hace es que si el texto no se encuentra en el idioma seleccionado
    ,se mostrará el texto en el idioma original*/
    return textos[lenguajesCodigo]?[llave] ??
        llave; // te devuelve el texto en el idioma seleccionado
  }
}
