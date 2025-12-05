import 'package:flutter/material.dart';

class MolGramosScreen extends StatefulWidget {
  const MolGramosScreen({super.key});

  @override
  State<MolGramosScreen> createState() => _MolGramosScreenState();
}

class _MolGramosScreenState extends State<MolGramosScreen> {
  final masaCtrl = TextEditingController();
  final molCtrl = TextEditingController();
  final mmCtrl = TextEditingController();

  double gramos = 0;
  double moles = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mol ↔ Gramos",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _input("Masa molar (g/mol)", mmCtrl),
            const SizedBox(height: 12),
            _input("Gramos (g)", masaCtrl),
            const SizedBox(height: 12),
            _input("Moles (mol)", molCtrl),

            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                double mm = double.tryParse(mmCtrl.text) ?? 0;
                double g = double.tryParse(masaCtrl.text) ?? 0;
                double mol = double.tryParse(molCtrl.text) ?? 0;

                setState(() {
                  if (g > 0 && mm > 0) moles = g / mm;
                  if (mol > 0 && mm > 0) gramos = mol * mm;
                });
              },
              child: const Text("Calcular"),
            ),

            const SizedBox(height: 20),

            Text(
              "Moles: ${moles.toStringAsFixed(4)} mol",
              style: const TextStyle(color: Colors.amberAccent, fontSize: 18),
            ),
            Text(
              "Gramos: ${gramos.toStringAsFixed(4)} g",
              style: const TextStyle(color: Colors.amberAccent, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController c) {
    return TextField(
      controller: c,
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
