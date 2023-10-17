import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.notoSansArmenianTextTheme(),
          useMaterial3: true,
        ),
        home: const PreviewGrid());
  }
}
