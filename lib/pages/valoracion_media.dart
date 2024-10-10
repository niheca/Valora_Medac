import 'package:flutter/material.dart';

class ValoracionMediaPage extends StatelessWidget {
  
  final String codigoPersona; // Código de la persona a valorar

  // Ejemplo de valoraciones predefinidas (puedes cambiar estas valoraciones según tu lógica)
  final Map<String, List<int>> valoraciones = {
    'Puntualidad': [8, 9, 7, 6, 10],
    'Colaboración': [7, 9, 8, 7, 9],
    'Responsabilidad': [10, 9, 9, 8, 10],
    'Comunicación': [6, 7, 8, 7, 9],
    'Liderazgo': [8, 8, 7, 8, 9],
  };

  ValoracionMediaPage({super.key, required this.codigoPersona});

  @override
  Widget build(BuildContext context) {
    // Calcular la media de cada pregunta
    Map<String, double> mediasValoraciones = calcularMedias(valoraciones);

    // Calcular la media total
    double mediaTotal = mediasValoraciones.values.reduce((a, b) => a + b) / mediasValoraciones.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media de Valoraciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar el código de la persona
            Text(
              'Código de la persona: $codigoPersona',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Generar las preguntas con sus medias
            Expanded(
              child: ListView.builder(
                itemCount: valoraciones.keys.length,
                itemBuilder: (context, index) {
                  String pregunta = valoraciones.keys.elementAt(index);
                  double media = mediasValoraciones[pregunta]!; // Obtener la media de la pregunta

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pregunta,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nota media: ${media.toStringAsFixed(2)}', // Mostrar la media con 2 decimales
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            // Mostrar la media total
            Text(
              'Nota media total: ${mediaTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Botón de Volver
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Regresar a la pantalla anterior
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Volver',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para calcular las medias de las valoraciones
  Map<String, double> calcularMedias(Map<String, List<int>> valoraciones) {
    Map<String, double> medias = {};
    valoraciones.forEach((pregunta, listaValoraciones) {
      double media = listaValoraciones.reduce((a, b) => a + b) / listaValoraciones.length;
      medias[pregunta] = media;
    });
    return medias;
  }
}
