import 'package:flutter/material.dart';
import 'package:movil/screens/login/login.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'package:movil/providers/auth_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _usernameController = TextEditingController();
  RecordModel? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _showUserId = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _fetchUser() {
    final authService = Provider.of<PocketBaseAuthNotifier>(
      context,
      listen: false,
    );
    final currentUser = authService.currentUser;

    if (authService.isAuthenticated) {
      setState(() {
        _user = currentUser;
        _usernameController.text = _user!.data['username'] ?? '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // If for some reason we land here without a user, kick back to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      });
    }
  }

  Future<void> _updateUsername() async {
    if (_user == null || _usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El nombre de usuario no puede estar vacío'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final authService = Provider.of<PocketBaseAuthNotifier>(
        context,
        listen: false,
      );
      await authService.updateUsername(
        _user!.id,
        _usernameController.text.trim(),
      );

      _fetchUser(); // Refresh user data

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Nombre actualizado exitosamente!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _logout() async {
    await Provider.of<PocketBaseAuthNotifier>(context, listen: false).logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _deleteAccount() async {
    if (_user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Cuenta'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final authService = Provider.of<PocketBaseAuthNotifier>(
          context,
          listen: false,
        );
        await authService.deleteAccount(_user!.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar cuenta: $e')),
          );
        }
      }
    }
  }

  String _getAvatarUrl() {
    final username = _user?.data['username'] ?? _user?.data['email'] ?? 'User';
    // Use the placeholder avatar service
    return 'https://avatar.iran.liara.run/username?username=$username';
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('No hay usuario autenticado.'))
          : CustomScrollView(
              slivers: [
                // App Bar with Gradient
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [colorScheme.primary, colorScheme.secondary],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          // Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.onPrimary,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(_getAvatarUrl()),
                              backgroundColor: colorScheme.surface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Username
                          Text(
                            _user!.data['username'] ?? 'Usuario',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          // Email
                          Text(
                            _user!.data['email'] ?? 'Sin email',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onPrimary.withOpacity(0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _logout,
                      tooltip: 'Cerrar Sesión',
                    ),
                  ],
                ),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Account Info Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Información de la Cuenta',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                _buildInfoRow(
                                  context,
                                  'Email',
                                  _user!.data['email'] ?? 'N/A',
                                  Icons.email_outlined,
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  context,
                                  'Cuenta Creada',
                                  _formatDate(_user!.data['created']),
                                  Icons.calendar_today,
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  context,
                                  'Última Actualización',
                                  _formatDate(_user!.data['updated']),
                                  Icons.update,
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  context,
                                  'Estado de Verificación',
                                  _user!.data['verified'] == true
                                      ? 'Verificado ✓'
                                      : 'No verificado',
                                  _user!.data['verified'] == true
                                      ? Icons.verified
                                      : Icons.warning_amber,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Edit Username Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Editar Perfil',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre de Usuario',
                                    prefixIcon: Icon(Icons.person_outline),
                                    helperText:
                                        'Actualiza tu nombre de usuario',
                                  ),
                                  enabled: !_isSaving,
                                ),
                                const SizedBox(height: 20),
                                FilledButton.icon(
                                  onPressed: _isSaving ? null : _updateUsername,
                                  icon: _isSaving
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: colorScheme.onPrimary,
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label: Text(
                                    _isSaving
                                        ? 'Guardando...'
                                        : 'Guardar Cambios',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Danger Zone Card
                        Card(
                          color: colorScheme.errorContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: colorScheme.onErrorContainer,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Zona de Peligro',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onErrorContainer,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Una vez que elimines tu cuenta, no hay vuelta atrás. Por favor, ten certeza.',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: colorScheme.onErrorContainer,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          setState(() {
                                            _showUserId = !_showUserId;
                                          });
                                        },
                                        icon: Icon(
                                          _showUserId
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        label: Text(
                                          _showUserId
                                              ? 'Ocultar ID'
                                              : 'Mostrar ID',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              colorScheme.onErrorContainer,
                                          side: BorderSide(
                                            color: colorScheme.onErrorContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: _deleteAccount,
                                        icon: const Icon(Icons.delete_forever),
                                        label: const Text('Eliminar Cuenta'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              colorScheme.onErrorContainer,
                                          side: BorderSide(
                                            color: colorScheme.onErrorContainer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_showUserId) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: colorScheme.onErrorContainer
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.fingerprint,
                                          size: 20,
                                          color: colorScheme.onSurface,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID de Usuario',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withOpacity(0.6),
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                _user!.id,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontFamily: 'monospace',
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary.withOpacity(0.7)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
