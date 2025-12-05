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

  @override
  void initState() {
    super.initState();
    _fetchUser();
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
      print(currentUser);
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
    if (_user == null) return;

    try {
      final authService = Provider.of<PocketBaseAuthNotifier>(
        context,
        listen: false,
      );
      await authService.updateUsername(_user!.id, _usernameController.text);

      _fetchUser(); // Refresh user data

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update username: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logout() {
    Provider.of<PocketBaseAuthNotifier>(context, listen: false).logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    if (_user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
        // _logout() is called inside deleteAccount, so no need to call it here.
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete account: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildAvatar() {
    if (_user == null || _user!.data['avatar'] == '') {
      return const CircleAvatar(
        radius: 50,
        child: Icon(Icons.person, size: 50),
      );
    }
    // "http://<host>/api/files/<collectionId>/<recordId>/<filename>"
    final authService = Provider.of<PocketBaseAuthNotifier>(
      context,
      listen: false,
    );
    // Check if avatar data exists before trying to get its URL
    final avatarFileName = _user!.data['avatar'];
    if (avatarFileName != null && avatarFileName.isNotEmpty) {
      final avatarUrl = authService.pb.files
          .getUrl(_user!, avatarFileName)
          .toString();
      return CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl));
    }

    return const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('No user is currently logged in.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildAvatar(),
                    const SizedBox(height: 20),
                    Text(
                      _user!.data['email'] ?? 'No Email Provided',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateUsername,
                      child: const Text('Save Changes'),
                    ),
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _deleteAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete Account'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
