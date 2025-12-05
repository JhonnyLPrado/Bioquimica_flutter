import 'package:flutter/material.dart';
import 'package:movil/screens/login/login.dart';
import 'package:provider/provider.dart';
import 'package:movil/screens/calculadora_quimica/calculadora_quimica_screen.dart';

// Providers
import 'providers/tabla_periodica_provider.dart';
import "package:movil/providers/auth_provider.dart";

// Screens
import 'screens/pantalla_tabla_periodica.dart';
import 'screens/reconocimiento_lewis_screen.dart';
import 'screens/login/user_profile.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://127.0.0.1:8090');

void main() {
  runApp(const BioquimicaApp());
}

class BioquimicaApp extends StatelessWidget {
  const BioquimicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TablaPeriodicaProvider()),
        ChangeNotifierProvider(create: (_) => PocketBaseAuthNotifier()),
      ],
      child: Consumer<PocketBaseAuthNotifier>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bioquímica — App de estudio',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.dark(
                primary: Colors.blue,
                secondary: Colors.green,
                surface: Colors.grey[800]!,
                background: Colors.grey[900]!,
                error: Colors.red,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.white,
                onBackground: Colors.white,
                onError: Colors.white,
              ),
            ),
            home: auth.isAuthenticated ? const HomePage() : const LoginScreen(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecordModel> _posts = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final resultList = await pb
          .collection('posts')
          .getFullList(
            sort: '@random', // Fetch random posts
            batch: 50, // Fetch up to 50 random posts
          );
      setState(() {
        _posts = resultList;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bioquímica — Inicio'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const SidePeriodicDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
          ? const Center(
              child: Text(
                "There has been an error",
                style: TextStyle(fontSize: 18),
              ),
            )
          : _posts.isEmpty
          ? const Center(
              child: Text(
                "Oops, there's nothing here!",
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8, // Adjust as needed
              ),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return PostCard(post: post);
              },
            ),
    );
  }
}

class PostCard extends StatelessWidget {
  final RecordModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Assuming 'image' is the field name for the image file
    // And 'pb.getFileUrl' constructs the correct URL for PocketBase
    final imageUrl = post.data['image'] != null
        ? pb.getFileUrl(post, post.data['image']).toString()
        : null;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (imageUrl != null)
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            )
          else
            const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.data['title'] ?? 'No Title',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  post.data['content'] ?? 'No Content',
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SidePeriodicDrawer extends StatelessWidget {
  const SidePeriodicDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text('Menú de navegación'),
              subtitle: Text('Opciones de estudio'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calculate, color: Colors.white),
              title: const Text(
                "Calculadora química",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CalculadoraQuimicaScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Reconocimiento Lewis"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReconocimientoLewisScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text("Tabla Periódica"),
              subtitle: const Text("Ver tabla completa"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PantallaTablaPeriodica(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("User Profile"),
              subtitle: const Text("View your profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UserProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
