import 'package:flutter/services.dart';
import 'package:my_nikki/screens/authentication/sign_up/sign_up.dart';
import 'package:my_nikki/screens/splash/splash.dart';
import 'package:my_nikki/screens/authentication/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_nikki/screens/home/home.dart';
import 'package:my_nikki/screens/widgets/new_entry.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env
  await dotenv.load(fileName: ".env");

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.secondaryColor,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const Login(),
          '/sign_up': (context) => const SignUp(),
          '/home': (context) => const Homepage(),
          '/newEntry': (context) => const NewEntryForm(),
        });
  }
}
