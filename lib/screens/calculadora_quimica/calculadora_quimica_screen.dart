import 'package:flutter/material.dart';
import 'boyle_screen.dart';
import 'charles_screen.dart';
import 'concentraciones_screen.dart';
import 'dalton_screen.dart';
import 'estequiometria_screen.dart';
import 'gay_lussac_screen.dart';
import 'gases_ideales_screen.dart';
import 'masa_molar_screen.dart';
import 'mol_gramos_screen.dart';

class CalculadoraQuimicaScreen extends StatelessWidget {
  const CalculadoraQuimicaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Calculadora Química",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _item(context, "Masa molar", const MasaMolarScreen()),
          _item(context, "Mol ↔ Gramos", const MolGramosScreen()),
          _item(context, "Estequiometría", const EstequiometriaScreen()),
          _item(context, "Concentraciones", const ConcentracionesScreen()),
          _item(context, "Ley de gases ideales", const GasesIdealesScreen()),
          _item(context, "Ley de Boyle-Mariotte", const BoyleScreen()),
          _item(context, "Ley de Dalton", const DaltonScreen()),
          _item(context, "Ley de Gay-Lussac", const GayLussacScreen()),
          _item(context, "Ley de Charles", const CharlesScreen()),
        ],
      ),
    );
  }

  Widget _item(BuildContext ctx, String text, Widget screen) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(text, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
        onTap: () =>
            Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}
