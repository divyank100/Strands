import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads_clone/firebase_options.dart';
import 'package:threads_clone/services/auth/auth_gate.dart';
import 'package:threads_clone/services/database/database_provider.dart';
import 'package:threads_clone/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
