import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import '../providers/tabla_periodica_provider.dart';
import '../models/elemento_quimico.dart';
import '../data/estructura_tabla.dart';
import '../screens/pantalla_elemento.dart';

class TablaPeriodicaWidget extends StatelessWidget {
  const TablaPeriodicaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TablaPeriodicaProvider>(context);
    final elementos = provider.elementos;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 18, // 18 columnas oficiales
        childAspectRatio: 1.1, // tamaño más cuadrado/estético
      ),
      itemCount: EstructuraTabla.estructura.length * 18,
      itemBuilder: (context, index) {
        int row = index ~/ 18;
        int col = index % 18;

        final atomicNumber = EstructuraTabla.estructura[row][col];

        if (atomicNumber == null) {
          return const SizedBox.shrink();
        }

        final elemento = elementos.firstWhere(
          (e) => e.numeroAtomico == atomicNumber,
        );

        return _ElementoTile(elemento: elemento);
      },
    );
  }
}

class _ElementoTile extends StatelessWidget {
  final ElementoQuimico elemento;

  const _ElementoTile({required this.elemento});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 450),
      closedColor: Color(
        int.parse(elemento.colorHex.replaceFirst('#', '0xff')),
      ),
      closedElevation: 0,
      openElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      openBuilder: (context, action) => PantallaElemento(elemento: elemento),
      closedBuilder: (context, action) => Container(
        margin: const EdgeInsets.all(3),
        child: Center(
          child: Text(
            elemento.simbolo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
