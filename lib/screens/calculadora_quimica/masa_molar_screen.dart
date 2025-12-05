import 'package:flutter/material.dart';

class MasaMolarScreen extends StatefulWidget {
  const MasaMolarScreen({super.key});

  @override
  State<MasaMolarScreen> createState() => _MasaMolarScreenState();
}

class _MasaMolarScreenState extends State<MasaMolarScreen> {
  final TextEditingController formulaCtrl = TextEditingController();
  double resultado = 0;

  Map<String, double> masas = {
    "H": 1.008,
    "O": 16.00,
    "C": 12.01,
    "N": 14.01,
    "Na": 22.99,
    "Cl": 35.45,
  };

  double calcularMasa(String formula) {
    double total = 0;

    RegExp reg = RegExp(r"([A-Z][a-z]?)(\d*)");

    for (var m in reg.allMatches(formula)) {
      String elemento = m.group(1)!;
      int cantidad = m.group(2)!.isEmpty ? 1 : int.parse(m.group(2)!);

      if (masas.containsKey(elemento)) {
        total += masas[elemento]! * cantidad;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Masa molar", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Ejemplo: H2O, CO2, NaCl",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: formulaCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Fórmula química",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  resultado = calcularMasa(formulaCtrl.text.trim());
                });
              },
              child: const Text("Calcular"),
            ),

            const SizedBox(height: 20),

            Text(
              "Masa molar: ${resultado.toStringAsFixed(3)} g/mol",
              style: const TextStyle(fontSize: 20, color: Colors.amberAccent),
            ),
          ],
        ),
      ),
    );
  }
}
