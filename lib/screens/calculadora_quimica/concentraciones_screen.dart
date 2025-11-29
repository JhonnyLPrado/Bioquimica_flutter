import 'package:flutter/material.dart';

class ConcentracionesScreen extends StatefulWidget {
  const ConcentracionesScreen({super.key});

  @override
  State<ConcentracionesScreen> createState() => _ConcentracionesScreenState();
}

class _ConcentracionesScreenState extends State<ConcentracionesScreen> {
  final solutoCtrl = TextEditingController();
  final solventeCtrl = TextEditingController();
  final volumenCtrl = TextEditingController();

  double molaridad = 0;
  double porcentajeMasa = 0;
  double ppm = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          "Concentraciones",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input("Masa de soluto (g)", solutoCtrl),
              const SizedBox(height: 12),
              _input("Masa de solvente (g)", solventeCtrl),
              const SizedBox(height: 12),
              _input("Volumen de solución (L)", volumenCtrl),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  double soluto = double.tryParse(solutoCtrl.text) ?? 0;
                  double solvente = double.tryParse(solventeCtrl.text) ?? 0;
                  double vol = double.tryParse(volumenCtrl.text) ?? 0;

                  setState(() {
                    molaridad = vol != 0 ? soluto / vol : 0;
                    porcentajeMasa = (soluto / (soluto + solvente)) * 100;
                    ppm = (soluto / (soluto + solvente)) * 1e6;
                  });
                },
                child: const Text("Calcular"),
              ),

              const SizedBox(height: 24),

              _resultado("Molaridad", "${molaridad.toStringAsFixed(4)} M"),
              _resultado("% masa", "${porcentajeMasa.toStringAsFixed(3)} %"),
              _resultado("PPM", "${ppm.toStringAsFixed(1)} ppm"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String t, TextEditingController c) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: t,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _resultado(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        "$titulo: $valor",
        style: const TextStyle(color: Colors.amberAccent, fontSize: 18),
      ),
    );
  }
}
