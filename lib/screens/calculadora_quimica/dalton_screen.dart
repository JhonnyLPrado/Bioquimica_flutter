import 'package:flutter/material.dart';

class DaltonScreen extends StatefulWidget {
  const DaltonScreen({super.key});

  @override
  State<DaltonScreen> createState() => _DaltonScreenState();
}

class _DaltonScreenState extends State<DaltonScreen> {
  final parcialesCtrl = TextEditingController();

  double presionTotal = 0;
  List<double> porcentajes = const <double>[];
  String mensaje =
      "Escribe las presiones parciales separadas por coma o espacio (ej. 0.5, 0.8, 0.3)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Ley de Dalton",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _input(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _calcular,
              child: const Text("Calcular presión total"),
            ),
            const SizedBox(height: 24),
            Text(
              mensaje,
              style: const TextStyle(color: Colors.amberAccent, fontSize: 16),
            ),
            if (porcentajes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                "Presión total = ${presionTotal.toStringAsFixed(4)} atm",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Aporte de cada gas:",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              ...List.generate(porcentajes.length, (i) {
                return Text(
                  "Gas ${i + 1}: ${porcentajes[i].toStringAsFixed(2)} %",
                  style: const TextStyle(color: Colors.white),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  void _calcular() {
    final texto = parcialesCtrl.text.trim();
    if (texto.isEmpty) {
      setState(() {
        mensaje = "Ingresa al menos una presión parcial";
        presionTotal = 0;
        porcentajes = const [];
      });
      return;
    }

    final partes = texto.split(RegExp(r'[;,\s]+'));
    final valores = <double>[];
    for (final parte in partes) {
      if (parte.isEmpty) continue;
      final valor = double.tryParse(parte);
      if (valor != null && valor > 0) {
        valores.add(valor);
      }
    }

    if (valores.isEmpty) {
      setState(() {
        mensaje = "No se detectaron valores numéricos válidos";
        presionTotal = 0;
        porcentajes = const [];
      });
      return;
    }

    final total = valores.fold<double>(0, (sum, v) => sum + v);

    setState(() {
      presionTotal = total;
      porcentajes = valores
          .map((v) => total == 0 ? 0.0 : (v / total) * 100.0)
          .toList(growable: false);
      mensaje = "La presión total es la suma de las parciales";
    });
  }

  Widget _input() {
    return TextField(
      controller: parcialesCtrl,
      maxLines: 3,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Presiones parciales (atm)",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        hintText: "0.5, 0.8, 1.2",
        hintStyle: const TextStyle(color: Colors.white38),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
