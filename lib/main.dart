import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrixmix/models.dart';
import 'package:matrixmix/settings.dart';
import 'package:matrixmix/ui/homePage.dart';
import 'package:matrixmix/ui/settingsPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefences = await SharedPreferences.getInstance();

  runApp(ChangeNotifierProvider(
      create: (context) => DSPServerModel(prefences), child: const MyApp()));
}

GoRouter router() {
  return GoRouter(initialLocation: '/settings', routes: [
    GoRoute(
      path: '/',
      name: HOME_PAGE,
      builder: (context, state) {
        return const HomePage(title: 'MatrixMix');
      },
    ),
    GoRoute(
      path: '/settings',
      name: SETTINGS_PAGE,
      builder: (context, state) {
        return const SettingsPage(title: 'Settings');
      },
    ),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MatrixMix',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2D7072), brightness: Brightness.dark),
        // dark theme
        useMaterial3: true,
      ),
      // home: const HomePage(title: 'MatrixMix'),
      routerConfig: router(),
    );
  }
}
