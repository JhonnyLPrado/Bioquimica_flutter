/// Util: calcula distribución de electrones por capas (modelo Bohr simplificado)
/// Devuelve una lista de longitud 7: [K, L, M, N, O, P, Q]
List<int> computeBohrShells(int atomicNumber) {
  // Capacidades por capa (Bohr simplificado usable para propósitos educativos)
  final capacities = [2, 8, 18, 32, 18, 8, 2];

  var remaining = atomicNumber;
  List<int> shells = [];

  for (var cap in capacities) {
    if (remaining <= 0) {
      shells.add(0);
      continue;
    }
    final take = remaining >= cap ? cap : remaining;
    shells.add(take);
    remaining -= take;
  }

  // ajuste fino para representar mejor la distribución real en capas medias:
  // mover excesos de la capa 3 a la 4 si la 3 supera 18 (opcional, pero mejora visual)
  if (shells[2] > 18) {
    final overflow = shells[2] - 18;
    shells[2] = 18;
    shells[3] = (shells[3] + overflow).clamp(0, 32);
  }

  return shells;
}
