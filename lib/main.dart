import 'package:flutter/material.dart';
import 'package:graville_operations/providers/language_provider.dart';
import 'package:graville_operations/providers/theme_provider.dart';
import 'package:graville_operations/screens/auth/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'graville operations',

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,

          // 🔥 LANGUAGE CONNECTION
          locale: languageProvider.locale,

          supportedLocales: const [
            Locale('en'),
            Locale('sw'), // Swahili 🇰🇪
          ],

          localizationsDelegates: const [
            // REQUIRED
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          home: const LoginScreen(),
        );
      },
    );
  }
}
