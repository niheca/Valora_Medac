import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

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

class EstadisticaPage extends StatelessWidget {
  final String codigo;

  

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

  EstadisticaPage({required this.codigo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Estadísticas del Profesor')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('profesores')
            .doc(codigo)
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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner superior
                Container(
                  width: double.infinity,
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
                        'Estadísticas',
                        style: TextStyle(color: Colors.white,fontSize: 40,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Información del profesor
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre: ${data['Nombre']}', style: TextStyle(fontSize: 18)),
                      Text('Apellidos: ${data['Apellidos']}', style: TextStyle(fontSize: 18)),
                      Text('Asignatura: ${data['Asignatura']}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Cálculo de estadísticas
                FutureBuilder<List<double>>(
                  future: _calcularEstadisticas(codigo),
                  builder: (context, statsSnapshot) {
                    if (statsSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (statsSnapshot.hasError) {
                      return Center(child: Text('Error al calcular las estadísticas'));
                    }

                    if (!statsSnapshot.hasData || statsSnapshot.data!.isEmpty) {
                      return Center(child: Text('No hay valoraciones aún'));
                    }

                    List<double> medias = statsSnapshot.data!;
                    double mediaGeneral = medias.reduce((a, b) => a + b) / medias.length; // Calcular la media general

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding para las valoraciones
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mostrar la media general
                          Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 43, 76, 0.1), 
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Media General: ${mediaGeneral.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(0, 43, 76, 1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Mostrar cada pregunta con su media
                          ...List.generate(medias.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preguntas[index],
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  // Mostrar la media
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 43, 76, 0.1), 
                                      borderRadius: BorderRadius.circular(20), 
                                    ),
                                    child: Text(
                                      medias[index].toStringAsFixed(2),
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 43, 76, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<List<double>> _calcularEstadisticas(String codigo) async {
    QuerySnapshot valoracionesSnapshot = await FirebaseFirestore.instance
        .collection('profesores')
        .doc(codigo)
        .collection('valoraciones')
        .get();

    List<List<int>> puntuacionesPorPregunta = List.generate(9, (index) => []);

    // Recopilar puntuaciones
    for (var doc in valoracionesSnapshot.docs) {
      List<int> puntuaciones = List.from(doc['puntuaciones']);
      for (int i = 0; i < puntuaciones.length; i++) {
        puntuacionesPorPregunta[i].add(puntuaciones[i]);
      }
    }

    // Calcular medias
    List<double> medias = puntuacionesPorPregunta.map((puntuaciones) {
      if (puntuaciones.isEmpty) {
        return 0.0; 
      }
      double suma = puntuaciones.fold(0, (a, b) => a + b);
      return suma / puntuaciones.length;
    }).toList();

    return medias;
  }
}