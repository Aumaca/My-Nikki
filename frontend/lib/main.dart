import 'package:my_nikki/models/entry.dart';
import 'package:my_nikki/screens/authentication/sign_up/sign_up.dart';
import 'package:my_nikki/screens/authentication/login.dart';
import 'package:my_nikki/screens/entries/entry.dart';
import 'package:my_nikki/screens/entries/new_entry.dart';
import 'package:my_nikki/screens/splash/splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_nikki/screens/home/home.dart';
import 'package:my_nikki/utils/colors.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const Login());
          case '/sign_up':
            return MaterialPageRoute(builder: (context) => const SignUp());
          case '/home':
            return MaterialPageRoute(builder: (context) => const Homepage());
          case '/newEntry':
            final updateUser = settings.arguments as void Function();
            return MaterialPageRoute(
                builder: (context) =>
                    NewEntryFormRoute(updateUser: updateUser));
          case '/entry':
            final args = settings.arguments as Map<String, dynamic>;
            final entry = args['entry'] as EntryModel;
            final updateUser = args['updateUser'] as void Function();
            return MaterialPageRoute(
                builder: (context) =>
                    EntryRoute(entry: entry, updateUser: updateUser));
          default:
            return MaterialPageRoute(
                builder: (context) => const SplashScreen());
        }
      },
    );
  }
}

class NewEntryFormRoute extends StatelessWidget {
  final void Function() updateUser;

  const NewEntryFormRoute({super.key, required this.updateUser});

  @override
  Widget build(BuildContext context) {
    return NewEntryForm(updateUser: updateUser);
  }
}

class EntryRoute extends StatelessWidget {
  final EntryModel entry;
  final void Function() updateUser;

  const EntryRoute({super.key, required this.entry, required this.updateUser});

  @override
  Widget build(BuildContext context) {
    return Entry(updateUser: updateUser, entry: entry);
  }
}
