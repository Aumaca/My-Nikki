import 'package:my_nikki/pages/authentication/login.dart';
import 'package:my_nikki/utils/secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env
  await dotenv.load(fileName: ".env");

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final SecureStorage secureStorage = SecureStorage();

  Future<String?> getUserToken() async {
    return await secureStorage.readToken();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
