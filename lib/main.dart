import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vetconnect/registration/login.dart';
import 'package:vetconnect/registration/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vetconnect/route_page.dart';
import 'package:vetconnect/setup_page.dart';
import 'firebase_options.dart';

void main() async {
  // load environment variables
  await dotenv.load(fileName: ".env");

  // setup openai options
  OpenAI.apiKey = await dotenv.env["OPENAI_API_KEY"]!;
  OpenAI.requestsTimeOut = Duration(seconds: 60);
  OpenAI.showLogs = true;

  // await the startup of firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegisterPage(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/setup': (context) => const SetupPage(),
        '/route': (context) => const RoutePage()
      },
    );
  }
}
