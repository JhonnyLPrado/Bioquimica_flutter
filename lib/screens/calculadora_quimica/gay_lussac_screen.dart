import 'package:flutter/material.dart';

class GayLussacScreen extends StatefulWidget {
  const GayLussacScreen({super.key});

  @override
  State<GayLussacScreen> createState() => _GayLussacScreenState();
}

class _GayLussacScreenState extends State<GayLussacScreen> {
  final p1Ctrl = TextEditingController();
  final t1Ctrl = TextEditingController();
  final t2Ctrl = TextEditingController();

  String resultado = "P₁ / T₁ = P₂ / T₂";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ley de Gay-Lussac",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("P₁ (atm)", p1Ctrl),
            const SizedBox(height: 12),
            _input("T₁ (K)", t1Ctrl),
            const SizedBox(height: 12),
            _input("T₂ (K)", t2Ctrl),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text("Calcular P₂"),
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
    final p1 = double.tryParse(p1Ctrl.text) ?? 0;
    final t1 = double.tryParse(t1Ctrl.text) ?? 0;
    final t2 = double.tryParse(t2Ctrl.text) ?? 0;

    if (p1 <= 0 || t1 <= 0 || t2 <= 0) {
      setState(() {
        resultado = "Todos los valores deben ser mayores que cero";
      });
      return;
    }

    final p2 = p1 * (t2 / t1);
    setState(() {
      resultado = "P₂ = ${p2.toStringAsFixed(4)} atm";
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
