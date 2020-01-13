library student_market_app.global;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_market_app/auth_service.dart';

enum Language {
  eng, swe
}

Language currentLanguage = Language.swe;
bool darkModeActive = false;

FirebaseUser user;
AuthService authService = AuthService();