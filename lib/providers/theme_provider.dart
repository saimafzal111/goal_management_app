import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Always use light theme
  ThemeMode get themeMode => ThemeMode.light;
  
  // Always return false for light mode only
  bool get isDarkMode => false;
}

