import 'package:flutter/material.dart';
import '../widgets/tabla_periodica_widget.dart';

class PantallaTablaPeriodica extends StatelessWidget {
  const PantallaTablaPeriodica({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tabla Periódica")),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 10),
            TablaPeriodicaWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
