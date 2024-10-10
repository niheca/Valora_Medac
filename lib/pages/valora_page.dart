import 'package:flutter/material.dart';

class ValoracionPage extends StatefulWidget {
  final String codigoPersona; // Código de la persona a valorar

  const ValoracionPage({super.key, required this.codigoPersona});

  @override
  _ValoracionPageState createState() => _ValoracionPageState();
}

class _ValoracionPageState extends State<ValoracionPage> {
  // Lista de preguntas
  final List<String> preguntas = [
    'Puntualidad',
    'Colaboración',
    'Responsabilidad',
    'Comunicación',
    'Liderazgo',
  ];

  // Mapa para almacenar la puntuación seleccionada por cada pregunta
  Map<String, int> valoraciones = {};

  @override
  void initState() {
    super.initState();
    // Inicializamos todas las valoraciones con el valor 1 por defecto
    for (var pregunta in preguntas) {
      valoraciones[pregunta] = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Valorar Persona'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar el código de la persona
            Text(
              'Código de la persona: ${widget.codigoPersona}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Generar las preguntas con el Dropdown para seleccionar la valoración
            Expanded(
              child: ListView.builder(
                itemCount: preguntas.length,
                itemBuilder: (context, index) {
                  String pregunta = preguntas[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pregunta,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<int>(
                        value: valoraciones[pregunta], // Valor actual de la pregunta
                        isExpanded: true,
                        items: List.generate(
                          10,
                          (i) => DropdownMenuItem(
                            value: i + 1, // Valores de 1 a 10
                            child: Text('${i + 1}'),
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            valoraciones[pregunta] = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),

            // Botón de Enviar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar Enviar (no definida aún)
                  print('Valoraciones enviadas: $valoraciones');
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
                  'Enviar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
