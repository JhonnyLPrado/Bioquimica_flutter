import 'package:flutter/material.dart';
import '../models/elemento_quimico.dart';
import '../widgets/atom_widget.dart';
import '../utils/bohr_shells.dart';

class PantallaElemento extends StatelessWidget {
  final ElementoQuimico elemento;

  const PantallaElemento({super.key, required this.elemento});

  @override
  Widget build(BuildContext context) {
    final colorCategoria = _getCategoriaColor(elemento.categoria);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          elemento.nombre,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // -------------------------------
            // COLUMNA IZQUIERDA
            // -------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // símbolo grande
                  Text(
                    elemento.simbolo,
                    style: TextStyle(
                      color: colorCategoria,
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: colorCategoria.withOpacity(0.35),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // nombre
                  Text(
                    elemento.nombre,
                    style: const TextStyle(color: Colors.white70, fontSize: 28),
                  ),

                  const SizedBox(height: 24),

                  // tarjeta de info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorCategoria.withOpacity(0.70),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Número atómico", "${elemento.numeroAtomico}"),
                        _infoRow(
                          "Protones / Electrones",
                          "${elemento.numeroAtomico}",
                        ),
                        _infoRow("Neutrones", "${elemento.neutrones}"),
                        _infoRow("Masa atómica", "${elemento.masaAtomica} u"),
                        _infoRow(
                          "Densidad",
                          elemento.densidad == null
                              ? "—"
                              : "${elemento.densidad} g/cm³",
                        ),
                        _infoRow(
                          "Radio atómico",
                          elemento.radioAtomico == null
                              ? "—"
                              : "${elemento.radioAtomico} pm",
                        ),
                        _infoRow(
                          "Estructura cristalina",
                          elemento.estructuraCristalina ?? "—",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 20),

            // -------------------------------
            // ÁTOMO ANIMADO
            // -------------------------------
            Column(
              children: [
                AtomWidget(
                  simbolo: elemento.simbolo,
                  numeroAtomico: elemento.numeroAtomico,
                  size: 260,
                  color: colorCategoria,
                ),

                const SizedBox(height: 12),

                Builder(
                  builder: (_) {
                    final shells = computeBohrShells(elemento.numeroAtomico);
                    return Text(
                      "Capas: ${shells.where((s) => s > 0).join(' - ')}",
                      style: const TextStyle(color: Colors.white70),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(title, style: const TextStyle(color: Colors.white70)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getCategoriaColor(String cat) {
    final c = cat.toLowerCase();
    if (c.contains("alcalino")) return Colors.blueAccent;
    if (c.contains("alcalinotérreo")) return Colors.lightBlue;
    if (c.contains("metaloide")) return Colors.orangeAccent;
    if (c.contains("halógeno")) return Colors.pinkAccent;
    if (c.contains("gas")) return Colors.amberAccent;
    if (c.contains("lantánido")) return Colors.purpleAccent;
    if (c.contains("actínido")) return Colors.redAccent;
    if (c.contains("transición")) return Colors.tealAccent;
    if (c.contains("no metal")) return Colors.greenAccent;
    return Colors.white70;
  }
}
