import 'package:flutter/material.dart';

class EstequiometriaScreen extends StatefulWidget {
  const EstequiometriaScreen({super.key});

  @override
  State<EstequiometriaScreen> createState() => _EstequiometriaScreenState();
}

class _EstequiometriaScreenState extends State<EstequiometriaScreen> {
  final molesA = TextEditingController();
  final coefA = TextEditingController();
  final coefB = TextEditingController();

  double resultado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Estequiometría",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Ejemplo de uso:\nSi 2H₂ + O₂ → 2H₂O\nCoef A = 2 (H₂)\nCoef B = 2 (H₂O)",
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 20),

            _input("Moles de A", molesA),
            const SizedBox(height: 12),
            _input("Coeficiente A", coefA),
            const SizedBox(height: 12),
            _input("Coeficiente B", coefB),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {
                double a = double.tryParse(molesA.text) ?? 0;
                double ca = double.tryParse(coefA.text) ?? 1;
                double cb = double.tryParse(coefB.text) ?? 1;

                setState(() {
                  resultado = a * (cb / ca);
                });
              },
              child: const Text("Calcular"),
            ),

            const SizedBox(height: 24),

            Text(
              "Moles de B producidos: ${resultado.toStringAsFixed(4)} mol",
              style: const TextStyle(fontSize: 20, color: Colors.amberAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String text, TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
