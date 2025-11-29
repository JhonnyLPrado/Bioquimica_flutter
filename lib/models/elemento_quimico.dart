class ElementoQuimico {
  final int numeroAtomico;
  final String simbolo;
  final String nombre;
  final double masaAtomica;
  final int grupo;
  final int periodo;
  final String categoria;
  final String colorHex;

  // Nuevos campos opcionales
  final double? densidad; // g/cm3 (cuando aplique)
  final double? radioAtomico; // pm (picómetros)
  final String? estructuraCristalina;

  const ElementoQuimico({
    required this.numeroAtomico,
    required this.simbolo,
    required this.nombre,
    required this.masaAtomica,
    required this.grupo,
    required this.periodo,
    required this.categoria,
    required this.colorHex,
    this.densidad,
    this.radioAtomico,
    this.estructuraCristalina,
  });

  /// Neutrones aproximados = masa atómica redondeada - número atómico
  int get neutrones => (masaAtomica.round()) - numeroAtomico;

  /// Protones = número atómico
  int get protones => numeroAtomico;

  /// Electrones (átomo neutro) = número atómico
  int get electrones => numeroAtomico;
}
