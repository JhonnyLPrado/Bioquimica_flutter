import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ReconocimientoLewisScreen extends StatefulWidget {
  const ReconocimientoLewisScreen({super.key});

  @override
  State<ReconocimientoLewisScreen> createState() =>
      _ReconocimientoLewisScreenState();
}

class _ReconocimientoLewisScreenState extends State<ReconocimientoLewisScreen> {
  Uint8List? imagenBytes;
  String? prediccion;
  String? confianza;

  final ImagePicker picker = ImagePicker();

  Future<void> seleccionarImagen() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img == null) return;

    final bytes = await img.readAsBytes();
    setState(() {
      imagenBytes = bytes;
      prediccion = null;
      confianza = null;
    });
  }

  Future<void> enviarAnalisis() async {
    if (imagenBytes == null) {
      setState(() {
        prediccion = "No se seleccionó imagen";
      });
      return;
    }

    final String img64 = base64Encode(imagenBytes!);

    final url = Uri.parse("http://127.0.0.1:8000/predict/base64");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"imagen": img64}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        prediccion = data["clase"]?.toString() ?? "—";
        confianza = data["confianza"]?.toString() ?? "—";
      });
    } else {
      setState(() {
        prediccion = "Error del servidor";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4ecff),
      appBar: AppBar(
        title: const Text("Reconocimiento Lewis"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: imagenBytes == null
                  ? const Center(
                      child: Text(
                        "No hay imagen seleccionada",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(imagenBytes!, fit: BoxFit.contain),
                    ),
            ),
            const SizedBox(height: 20),

            // Seleccionar imagen
            ElevatedButton(
              onPressed: seleccionarImagen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Seleccionar imagen"),
            ),

            const SizedBox(height: 10),

            // Enviar análisis
            ElevatedButton(
              onPressed: enviarAnalisis,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Enviar para análisis"),
            ),

            const SizedBox(height: 30),

            // Resultado
            Text(
              "Predicción: ${prediccion ?? '—'}  (${confianza ?? '—'})",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
