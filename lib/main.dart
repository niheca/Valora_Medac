import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'valorar_page.dart';
import 'estadistica_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    runApp(MyApp());
  }).catchError((error) {
    print("Error durante la inicialización de Firebase: $error");
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CenturyGothic',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _codigoController = TextEditingController();

  Color buttonColor = const Color.fromARGB(255, 0, 43, 76);
  Color textColor = Colors.white;
  Color borderColor = const Color.fromARGB(255, 0, 43, 76);

  void _navegarAValorar() {
    String codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      _mostrarMensajeError("Por favor, ingresa el código del profesor.");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ValorarPage(codigo: codigo)),
    );
  }

  void _navegarAEstadistica() {
    String codigo = _codigoController.text.trim();
    if (codigo.isEmpty) {
      _mostrarMensajeError("Por favor, ingresa el código del profesor.");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EstadisticaPage(codigo: codigo)),
    );
  }

  void _mostrarMensajeError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // padding lateral
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/medacicon.png',
              width: 300.0,
              height: 300.0,
            ),
            Text(
              'Valoración de Profesores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Contenedor del TextField
            Center(
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _codigoController,
                  decoration: InputDecoration(
                    labelText: 'Código del Profesor',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30), 
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _navegarAValorar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    minimumSize: Size(305, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Valorar',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 30), // espacio entre botones
                ElevatedButton(
                  onPressed: _navegarAEstadistica,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    minimumSize: Size(305, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Estadística',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}