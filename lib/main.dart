import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'screens/signup_screen.dart';

final logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    logger.i('SHOPIFY_DOMAIN: ${dotenv.env['SHOPIFY_DOMAIN']}');
    logger.i(
      'SHOPIFY_TOKEN: ${dotenv.env['SHOPIFY_TOKEN']?.substring(0, 8)}...',
    );
  } catch (e) {
    logger.e("Failed to load .env file", error: e);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tidy Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: SignupScreen(),
    );
  }
}
