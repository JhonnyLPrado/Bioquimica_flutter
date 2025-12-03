import 'package:flutter/material.dart';

class CharlesScreen extends StatefulWidget {
  const CharlesScreen({super.key});

  @override
  State<CharlesScreen> createState() => _CharlesScreenState();
}

class _CharlesScreenState extends State<CharlesScreen> {
  final v1Ctrl = TextEditingController();
  final t1Ctrl = TextEditingController();
  final t2Ctrl = TextEditingController();

  String resultado = "V₁ / T₁ = V₂ / T₂";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ley de Charles",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("V₁ (L)", v1Ctrl),
            const SizedBox(height: 12),
            _input("T₁ (K)", t1Ctrl),
            const SizedBox(height: 12),
            _input("T₂ (K)", t2Ctrl),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text("Calcular V₂"),
            ),
            const SizedBox(height: 24),
            Text(
              resultado,
              style: const TextStyle(color: Colors.amberAccent, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _calcular() {
    final v1 = double.tryParse(v1Ctrl.text) ?? 0;
    final t1 = double.tryParse(t1Ctrl.text) ?? 0;
    final t2 = double.tryParse(t2Ctrl.text) ?? 0;

    if (v1 <= 0 || t1 <= 0 || t2 <= 0) {
      setState(() {
        resultado = "Todos los valores deben ser mayores que cero";
      });
      return;
    }

    final v2 = v1 * (t2 / t1);
    setState(() {
      resultado = "V₂ = ${v2.toStringAsFixed(4)} L";
    });
  }

  Widget _input(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
