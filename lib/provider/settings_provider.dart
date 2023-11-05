import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:system_theme/system_theme.dart';

class SettingProvider extends ChangeNotifier {
  late Box settingBox;
  SettingProvider() {
    settingBox = Hive.box('settingBox');
    toggleTheme(
        SchedulerBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark);
  }
  ThemeData _themeData = ThemeData.dark();
  ThemeData get themeData => _themeData;

  void toggleTheme(bool isDark) {
    if (isDark) {
      _themeData = ThemeData(
        dividerColor: Colors.transparent,
        primaryColor: SystemTheme.accentColor.accent,
        brightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            fillColor: Colors.grey[600],
            filled: true),
        textTheme: GoogleFonts.notoSansArmenianTextTheme()
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
        useMaterial3: true,
      );
      settingBox.put('darkMode', true);
    } else {
      _themeData = ThemeData(
        dividerColor: Colors.transparent,
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(color: Colors.grey[300]!)),
            fillColor: Colors.white,
            filled: true),
        primaryColor: SystemTheme.accentColor.accent,
        textTheme: GoogleFonts.notoSansArmenianTextTheme()
            .apply(bodyColor: Colors.black, displayColor: Colors.black),
        useMaterial3: true,
      );
      settingBox.put('darkMode', false);
    }
    notifyListeners();
  }
}
