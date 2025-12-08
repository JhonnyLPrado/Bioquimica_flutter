import 'package:flutter/material.dart';
import '../../widgets/atom_widget.dart';

class LewisTutorialScreen extends StatelessWidget {
  const LewisTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial: Estructuras de Lewis'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '¿Qué son las Estructuras de Lewis?',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Las estructuras de Lewis son representaciones gráficas que muestran los enlaces entre átomos de una molécula y los pares de electrones solitarios que puedan existir.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Fueron introducidas por Gilbert N. Lewis en 1916 y son fundamentales para entender la química molecular.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Atom Demonstration Section
            Text(
              'Elementos Comunes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Estos son algunos de los elementos más comunes en las estructuras de Lewis:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Atom Widgets
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildAtomRow(
                      context,
                      'Hidrógeno (H)',
                      'El elemento más simple, con 1 electrón',
                      const AtomWidget(
                        simbolo: 'H',
                        numeroAtomico: 1,
                        size: 120,
                        color: Color(0xFF4DB6AC),
                      ),
                    ),
                    const Divider(height: 32),
                    _buildAtomRow(
                      context,
                      'Carbono (C)',
                      'Base de la química orgánica, con 6 electrones',
                      const AtomWidget(
                        simbolo: 'C',
                        numeroAtomico: 6,
                        size: 120,
                        color: Color(0xFF4DB6AC),
                      ),
                    ),
                    const Divider(height: 32),
                    _buildAtomRow(
                      context,
                      'Oxígeno (O)',
                      'Esencial para la vida, con 8 electrones',
                      const AtomWidget(
                        simbolo: 'O',
                        numeroAtomico: 8,
                        size: 120,
                        color: Color(0xFF4DB6AC),
                      ),
                    ),
                    const Divider(height: 32),
                    _buildAtomRow(
                      context,
                      'Nitrógeno (N)',
                      'Componente de aminoácidos, con 7 electrones',
                      const AtomWidget(
                        simbolo: 'N',
                        numeroAtomico: 7,
                        size: 120,
                        color: Color(0xFF4DB6AC),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Rules Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rule,
                          color: colorScheme.secondary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Reglas Básicas',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRuleItem(
                      context,
                      '1',
                      'Cuenta los electrones de valencia',
                      'Suma todos los electrones de valencia de los átomos en la molécula.',
                    ),
                    const SizedBox(height: 12),
                    _buildRuleItem(
                      context,
                      '2',
                      'Conecta los átomos',
                      'El átomo central suele ser el menos electronegativo (excepto H).',
                    ),
                    const SizedBox(height: 12),
                    _buildRuleItem(
                      context,
                      '3',
                      'Completa los octetos',
                      'Distribuye los electrones para que cada átomo tenga 8 (regla del octeto).',
                    ),
                    const SizedBox(height: 12),
                    _buildRuleItem(
                      context,
                      '4',
                      'Verifica la estructura',
                      'Asegúrate de que todos los electrones estén contabilizados.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Practice Section
            Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: colorScheme.onPrimaryContainer,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '¡Practica con la cámara!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Usa la función de Reconocimiento Lewis para tomar fotos de estructuras y obtener retroalimentación instantánea.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Ir a Reconocimiento'),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Placeholder for future interactive content
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.construction,
                      size: 48,
                      color: colorScheme.tertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Contenido Interactivo Próximamente',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Estamos trabajando en ejercicios interactivos, simulaciones y desafíos para ayudarte a dominar las estructuras de Lewis.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAtomRow(
    BuildContext context,
    String title,
    String description,
    Widget atomWidget,
  ) {
    return Row(
      children: [
        atomWidget,
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
