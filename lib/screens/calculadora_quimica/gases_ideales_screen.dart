import 'package:flutter/material.dart';

class GasesIdealesScreen extends StatefulWidget {
  const GasesIdealesScreen({super.key});

  @override
  State<GasesIdealesScreen> createState() => _GasesIdealesScreenState();
}

class _GasesIdealesScreenState extends State<GasesIdealesScreen> {
  final pCtrl = TextEditingController();
  final vCtrl = TextEditingController();
  final tCtrl = TextEditingController();

  double resultado = 0;
  final double R = 0.082057; // L·atm / mol·K

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ley de Gases Ideales",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Presión (atm)", pCtrl),
            const SizedBox(height: 12),
            _input("Volumen (L)", vCtrl),
            const SizedBox(height: 12),
            _input("Temperatura (K)", tCtrl),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                double P = double.tryParse(pCtrl.text) ?? 0;
                double V = double.tryParse(vCtrl.text) ?? 0;
                double T = double.tryParse(tCtrl.text) ?? 0;

                setState(() {
                  resultado = (P * V) / (R * T);
                });
              },
              child: const Text("Calcular moles"),
            ),

            const SizedBox(height: 24),

            Text(
              "Cantidad de sustancia: ${resultado.toStringAsFixed(4)} mol",
              style: const TextStyle(color: Colors.amberAccent, fontSize: 20),
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
