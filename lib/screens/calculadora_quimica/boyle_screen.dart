import 'package:flutter/material.dart';

class BoyleScreen extends StatefulWidget {
  const BoyleScreen({super.key});

  @override
  State<BoyleScreen> createState() => _BoyleScreenState();
}

class _BoyleScreenState extends State<BoyleScreen> {
  final p1Ctrl = TextEditingController();
  final v1Ctrl = TextEditingController();
  final p2Ctrl = TextEditingController();
  final v2Ctrl = TextEditingController();

  String resultado = "Introduce los datos para usar P₁V₁ = P₂V₂";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ley de Boyle-Mariotte",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("P₁ (atm)", p1Ctrl),
            const SizedBox(height: 12),
            _input("V₁ (L)", v1Ctrl),
            const SizedBox(height: 12),
            _input("P₂ (atm)", p2Ctrl),
            const SizedBox(height: 12),
            _input("V₂ (L)", v2Ctrl),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _calcular, child: const Text("Calcular")),
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
    final v1 = double.tryParse(v1Ctrl.text) ?? 0;
    final p2 = double.tryParse(p2Ctrl.text) ?? 0;
    final v2 = double.tryParse(v2Ctrl.text) ?? 0;

    if (p1 <= 0 || v1 <= 0) {
      setState(() {
        resultado = "Ingresa valores válidos para P₁ y V₁";
      });
      return;
    }

    if (p2 > 0 && v2 > 0) {
      final lhs = p1 * v1;
      final rhs = p2 * v2;
      final diff = (lhs - rhs).abs();
      setState(() {
        resultado =
            "P₁V₁ = ${lhs.toStringAsFixed(4)} y P₂V₂ = ${rhs.toStringAsFixed(4)}\n" +
            (diff < 1e-3
                ? "Los valores cumplen la ley"
                : "Los valores no coinciden");
      });
      return;
    }

    if (v2 > 0) {
      final nuevoP2 = (p1 * v1) / v2;
      setState(() {
        resultado = "P₂ = ${nuevoP2.toStringAsFixed(4)} atm";
      });
      return;
    }

    if (p2 > 0) {
      final nuevoV2 = (p1 * v1) / p2;
      setState(() {
        resultado = "V₂ = ${nuevoV2.toStringAsFixed(4)} L";
      });
      return;
    }

    setState(() {
      resultado = "Ingresa al menos P₂ o V₂ para calcular";
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
