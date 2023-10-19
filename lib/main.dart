import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'db/favorite_type_adapter.dart';
import 'provider/provider.dart';
import 'screens/screens.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    if (inDebug) {
      return ErrorWidget(details.exception);
    }
    return Container(
      alignment: Alignment.center,
      child: Text(details.exception.toString()),
    );
  };
  await dotenv.load(fileName: "lib/.env");
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteAdapter());
  await Hive.openBox<Favorite>('favoriteBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteProvider>(
          lazy: true,
          create: (context) => FavoriteProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(
          lazy: true,
          create: (context) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wallpaper Demo App',
          theme: ThemeData(
            dividerColor: Colors.transparent,
            brightness: Brightness.dark,
            textTheme: GoogleFonts.notoSansArmenianTextTheme(),
            useMaterial3: true,
          ),
          home: const HomeScreen()),
    );
  }
}
