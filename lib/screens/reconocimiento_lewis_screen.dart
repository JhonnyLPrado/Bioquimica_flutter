import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/auth_provider.dart';

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
  bool isLoading = false;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una imagen primero'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
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
        final userId = authProvider.currentUser?.id;

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
                    'result': prediccion ?? '—',
                  },
                  files: [
                    http.MultipartFile.fromBytes(
                      'image',
                      imagenBytes!,
                      filename:
                          'lewis_structure_${DateTime.now().millisecondsSinceEpoch}.png',
                    ),
                  ],
                );
            print('Post created in PocketBase: ${post.id}');

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Análisis guardado exitosamente')),
              );
            }
          } on ClientException catch (e) {
            print('PocketBase error creating post: ${e.response}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error al guardar: ${e.response}')),
              );
            }
          } catch (e) {
            print('Unknown error creating post: $e');
          }
        }
      } else {
        setState(() {
          prediccion = "Error del servidor";
        });
      }
    } catch (e) {
      print('Error during analysis: $e');
      setState(() {
        prediccion = "Error de conexión";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Reconocimiento Lewis"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview card
            Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 300,
                decoration: BoxDecoration(color: colorScheme.surface),
                child: imagenBytes == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 64,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No hay imagen seleccionada",
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Image.memory(imagenBytes!, fit: BoxFit.contain),
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: isLoading ? null : seleccionarImagen,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Seleccionar imagen"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: isLoading ? null : enviarAnalisis,
                    icon: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(isLoading ? "Analizando..." : "Analizar"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Results section
            if (prediccion != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.science,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Resultados del Análisis",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildResultRow(
                        context,
                        "Predicción",
                        prediccion ?? "—",
                        Icons.check_circle_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildResultRow(
                        context,
                        "Confianza",
                        confianza ?? "—",
                        Icons.percent,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.secondary, size: 20),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
