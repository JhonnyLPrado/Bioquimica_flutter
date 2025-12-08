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
import 'screens/lewis_tutorial/lewis_tutorial_screen.dart';
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
                primary: const Color(
                  0xFF4FC3F7,
                ), // Cyan 300 - Knowledge, clarity
                primaryContainer: const Color(
                  0xFF0277BD,
                ), // Cyan 800 - Deeper primary
                secondary: const Color(
                  0xFF26C6DA,
                ), // Cyan 400 - Scientific, energetic
                secondaryContainer: const Color(
                  0xFF00838F,
                ), // Cyan 900 - Deeper secondary
                tertiary: const Color(0xFF80CBC4), // Teal 200 - Accent
                tertiaryContainer: const Color(0xFF00695C), // Teal 800
                surface: const Color(0xFF1E2428), // Deep blue-grey surface
                surfaceVariant: const Color(
                  0xFF2C3339,
                ), // Slightly lighter variant
                background: const Color(0xFF121517), // Very dark background
                error: const Color(0xFFCF6679), // Material Design error
                onPrimary: const Color(0xFF001F24), // Dark on primary
                onPrimaryContainer: const Color(0xFFB3E5FC), // Light cyan
                onSecondary: const Color(0xFF003135), // Dark on secondary
                onSecondaryContainer: const Color(0xFFB2EBF2), // Light cyan
                onTertiary: const Color(0xFF00251A), // Dark on tertiary
                onTertiaryContainer: const Color(0xFFB2DFDB), // Light teal
                onSurface: const Color(
                  0xFFE1E3E5,
                ), // Off-white for better readability
                onSurfaceVariant: const Color(0xFFBFC1C3), // Muted text
                onBackground: const Color(0xFFE1E3E5), // Off-white
                onError: const Color(0xFF000000), // Black on error
                outline: const Color(0xFF8B9297), // Subtle borders
                outlineVariant: const Color(0xFF3F484D), // More subtle borders
                shadow: const Color(0xFF000000),
                scrim: const Color(0xFF000000),
                inverseSurface: const Color(0xFFE1E3E5),
                inversePrimary: const Color(0xFF006875),
                surfaceTint: const Color(0xFF4FC3F7),
              ),
              // Typography
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontSize: 57,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.25,
                ),
                displayMedium: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                ),
                displaySmall: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                ),
                headlineLarge: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ),
                headlineMedium: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
                headlineSmall: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                titleLarge: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
                titleMedium: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
                titleSmall: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                bodyLarge: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                bodyMedium: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
                bodySmall: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                ),
                labelLarge: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                labelMedium: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                labelSmall: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              // Card Theme
              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
              ),
              // AppBar Theme
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
                scrolledUnderElevation: 3,
              ),
              // Navigation Drawer Theme
              drawerTheme: DrawerThemeData(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                elevation: 16,
              ),
              // Button Themes
              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              // Input Decoration Theme
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              // Dialog Theme
              dialogTheme: DialogThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 24,
              ),
              // Bottom Sheet Theme
              bottomSheetTheme: const BottomSheetThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                elevation: 16,
              ),
              // Snackbar Theme
              snackBarTheme: SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Divider Theme
              dividerTheme: const DividerThemeData(space: 1, thickness: 1),
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
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.science,
                    size: 48,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bioquímica',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Opciones de estudio',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text("Calculadora química"),
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
              leading: const Icon(Icons.science),
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
              leading: const Icon(Icons.book),
              title: const Text("Tutorial de Lewis"),
              subtitle: const Text("Aprende sobre estructuras"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LewisTutorialScreen(),
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
