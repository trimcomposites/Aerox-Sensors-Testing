class StatusCode {
  //Red
  static const int networkError = 1; 
  static const int serverError = 2; 

  //Autenticación
  static const int authenticationFailed = 3; 
  static const int accountDisabled = 4; 
  static const int accountNotVerified = 5; 
  static const int invalidCredentials = 6; 

  //Google
  static const int googleSignInError = 7; 
  static const int googleSignInCancelled = 8;

  //Registro
  static const int registrationFailed = 9; 
  static const int weakPassword = 10; 
  static const int emailAlreadyInUse = 11; 

  //Restablecimiento de Contraseña
  static const int passwordResetFailed = 12; 
  static const int invalidEmailForReset = 13; 
}