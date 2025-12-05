import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart'; // Import provider to access auth state
import '../../main.dart'; // Import main.dart to access the global pb instance
import '../../providers/auth_provider.dart'; // Import auth_provider to get user ID

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

      // Save to PocketBase as a new post
      final authProvider = Provider.of<PocketBaseAuthNotifier>(
        context,
        listen: false,
      );
      final userId = authProvider
          .currentUser
          ?.id; // Corrected to use the ID of the user record

      if (userId != null && imagenBytes != null) {
        try {
          final RecordModel post = await pb
              .collection('posts')
              .create(
                body: {
                  'title': 'Lewis Structure Prediction',
                  'content':
                      'Predicted: ${prediccion ?? '—'} with confidence: ${confianza ?? '—'}',
                  'user': userId,
                  'prediction': prediccion ?? '—',
                  'result':
                      prediccion ??
                      '—', // For now, result is same as prediction
                },
                files: [
                  http.MultipartFile.fromBytes(
                    'image', // Field name for the image in PocketBase
                    imagenBytes!,
                    filename:
                        'lewis_structure_${DateTime.now().millisecondsSinceEpoch}.png',
                  ),
                ],
              );
          print('Post created in PocketBase: ${post.id}');
        } on ClientException catch (e) {
          print('PocketBase error creating post: ${e.response}');
          // Optionally, display an error to the user
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Failed to save post: ${e.response['message']}\')),\n          // );
        } catch (e) {
          print('Unknown error creating post: $e');
        }
      }
    } else {
      setState(() {
        prediccion = "Error del servidor";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reconocimiento Lewis"), elevation: 0),
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
