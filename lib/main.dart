// utils
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yt_converter/utils/permissions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// screens
import 'package:yt_converter/screens/splash.dart';

// services
import 'package:yt_converter/services/notification.dart';

// configs
import 'config/appbar_theme.dart';

// global object for accessing device screen size
late Size mq;

void main() async {
  // init flutter widget binding
  WidgetsFlutterBinding.ensureInitialized();

  // Check and request permissions
  await checkAndRequestPermissions();

  // Enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // for setting orientations to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) async {
    // consume dotenv
    await dotenv.load(fileName: ".env");

    // Create a ProviderContainer
    final container = ProviderContainer();

    // Initialize notification service
    await container.read(notificationServiceProvider).initNotification();

    // run app
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const App(),
      ),
    );
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
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        appBarTheme: appBarConfig(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
