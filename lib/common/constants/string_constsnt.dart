class StringConstants {
  static RegExp emailPatten = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static RegExp passPatten = RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
  static RegExp phonePatten = RegExp(r"^[0-9]");
  static String email = "Email";
  static String password = "Password";
  static String signIn = "Sign in";
  static String signInWithGoogle = " - Sign in with google";
  static String isEmailEmpty = "Enter email";
  static String isPasswordEmpty = "Enter password";
  static String isEmailNotMatch = "Enter valid email";
  static String snackBarText = "Logout Successfully!";
  static String logoutButtonText = "Logout";
  static String phoneNumber = "Phone Number";
  static String logoutGoogleButtonText = "Log out google account";
  static String isPasswordNotMatch = """
Minimum 8 characters, 
at least one uppercase letter, 
one lowercase letter, 
one number and one special character""";

  //static bool isAdmin = false;
}
