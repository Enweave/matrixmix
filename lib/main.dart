import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrixmix/models.dart';
import 'package:matrixmix/ui/homePage.dart';
import 'package:matrixmix/ui/settingsPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DSPServerModel(), child: const MyApp()));
}

GoRouter router() {
  return GoRouter(
      initialLocation: '/',
      routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomePage(title: 'MatrixMix');
      },
    ),
    GoRoute(
      path: '/settings',
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
    return MultiProvider(
        providers: [
          Provider(
              create: (context) => DSPServerModel(),
          ),
          ChangeNotifierProvider<DSPServerModel>(
            create: (context) => DSPServerModel(),
          ),
        ],
        child: MaterialApp.router(
          title: 'MatrixMix',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF2D7072), brightness: Brightness.dark),
            // dark theme
            useMaterial3: true,
          ),
          // home: const HomePage(title: 'MatrixMix'),
          routerConfig: router(),
        ));
  }
}
