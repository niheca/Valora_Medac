import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child : Text('MEDAC VALORA')) ,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de texto para el código de la persona
            TextField(
              decoration: InputDecoration(
                labelText: 'Código de la persona',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40), // Espacio entre el TextField y los botones

            // Botones centrados en la parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón de "Valorar"
                ElevatedButton(
                  onPressed: () async {
                    // Acción para el botón Valorar (por ahora nada)
                    await Navigator.pushNamed(context, '/valora');
                    setState((){});
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Valorar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                // Botón de "Estadísticas"
                ElevatedButton(
                  onPressed: () async {
                    // Acción para el botón Estadísticas (por ahora nada)
                    await Navigator.pushNamed(context, '/media');
                    setState((){});
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Estadísticas',
                    style: TextStyle(fontSize: 18),
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
