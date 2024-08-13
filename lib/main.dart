// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// screens
import 'package:yt_converter/screens/splash.dart';

// configs
import 'config/appbar_theme.dart';

// global object for accessing device screen size
late Size mq;

void main() async {
  // init flutter widget binding
  WidgetsFlutterBinding.ensureInitialized();
  // Enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // for setting orientations to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) async {
    // consume dotenv
    await dotenv.load(fileName: ".env");
    // run app
    runApp(const ProviderScope(child: App()));
  });
}

// app
class App extends ConsumerWidget {
  // init key
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yt Converter',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        appBarTheme: appBarConfig(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
