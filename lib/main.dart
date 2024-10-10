import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:valora_profesores_medac/pages/home_page.dart';
import 'package:valora_profesores_medac/pages/valoracion_media.dart';
import 'package:valora_profesores_medac/pages/valora_page.dart';
import 'package:valora_profesores_medac/services/profesores_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "valora project",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApplication());
}
class MyApplication extends StatefulWidget {
  const MyApplication({super.key});

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/valora': (context) => const ValoracionPage(codigoPersona: "12345"),
        '/media': (context) =>  ValoracionMediaPage(codigoPersona: "12345"),
      },
      
    );
  }
}

