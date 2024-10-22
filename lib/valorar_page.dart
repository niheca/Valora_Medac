import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class ValorarPage extends StatefulWidget {
  final String codigo;

  ValorarPage({required this.codigo});

  @override
  _ValorarPageState createState() => _ValorarPageState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CenturyGothic', // Establece la fuente
      ),
      home: HomePage(),
    );
  }
}

class _ValorarPageState extends State<ValorarPage> {
  final List<String> preguntas = [
    '¿Explica los conceptos claramente?',
    '¿Las clases están bien estructuradas?',
    '¿Fomenta la participación de los estudiantes?',
    '¿Domina el contenido que enseña?',
    '¿Utiliza materiales didácticos efectivos?',
    '¿Ajusta su enfoque según las necesidades?',
    '¿Proporciona retroalimentación útil?',
    '¿Es respetuoso y profesional?',
    '¿Muestra motivación por la materia?',
  ];

  late List<ValueNotifier<int>> puntuaciones;

  @override
  void initState() {
    super.initState();
    puntuaciones = List.generate(preguntas.length,
        (index) => ValueNotifier<int>(1)); // Inicializando con 1
  }

  @override
  void dispose() {
    for (var notifier in puntuaciones) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Valorar Profesor')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('profesores')
            .doc(widget.codigo)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar los datos'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Profesor no encontrado'));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            children: [
              // Banner superior
              Container(
                color: Color.fromRGBO(0, 43, 76, 1),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/medaciconw.png',
                      width: 70,
                      height: 70,
                    ),
                    SizedBox(width: 9),
                    Text(
                      'Valoración',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Información del profesor
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombre: ${data['Nombre']}',
                        style: TextStyle(fontSize: 18)),
                    Text('Apellidos: ${data['Apellidos']}',
                        style: TextStyle(fontSize: 18)),
                    Text('Asignatura: ${data['Asignatura']}',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Listado de preguntas
              ...List.generate(preguntas.length, (index) {
                return PreguntaSlider(
                  pregunta: preguntas[index],
                  puntuacionNotifier: puntuaciones[index],
                );
              }),

              // Botón para enviar la valoración
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromRGBO(0, 43, 76, 1), 
                    foregroundColor: Colors.white, 
                    minimumSize: Size(300, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), 
                    ),
                  ),
                  onPressed: () => _guardarValoracion(),
                  child: Text('Enviar Valoración',
                      style: TextStyle(
                          fontSize: 30)), 
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _guardarValoracion() async {
    try {
      // Extraer las puntuaciones
      List<int> scores = puntuaciones.map((e) => e.value).toList();

      // Guardar las puntuaciones en Firestore
      await FirebaseFirestore.instance
          .collection('profesores')
          .doc(widget.codigo)
          .collection('valoraciones')
          .add({
        'puntuaciones': scores,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Valoración enviada con éxito')),
      );

      // Regresar a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      print("Error al guardar la valoración: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la valoración')),
      );
    }
  }
}

class PreguntaSlider extends StatelessWidget {
  final String pregunta;
  final ValueNotifier<int> puntuacionNotifier;

  PreguntaSlider({required this.pregunta, required this.puntuacionNotifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(pregunta,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ValueListenableBuilder<int>(
            valueListenable: puntuacionNotifier,
            builder: (context, puntuacion, child) {
              return Column(
                children: [
                  Slider(
                    value: puntuacion.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: puntuacion.toString(),
                    onChanged: (value) {
                      puntuacionNotifier.value =
                          value.round(); // Actualiza el valor del ValueNotifier
                    },
                  ),
                  Text('Puntuación: $puntuacion',
                      style: TextStyle(fontSize: 14)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
