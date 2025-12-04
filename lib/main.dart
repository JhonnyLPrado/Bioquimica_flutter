import 'package:flutter/material.dart';
import 'package:movil/screens/login/login.dart';
import 'package:provider/provider.dart';
import 'package:movil/screens/calculadora_quimica/calculadora_quimica_screen.dart';
import 'package:pocketbase/pocketbase.dart';

// Providers
import 'providers/tabla_periodica_provider.dart';

// Screens
import 'screens/pantalla_tabla_periodica.dart';
import 'screens/reconocimiento_lewis_screen.dart';

// Util
import 'utils/auth_util.dart';

// The usual, pb

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
      ],
      child: MaterialApp(
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
        home: pb.authStore.isValid ? const HomePage() : const LoginScreen(),
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
  // Build, the usual.
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
      body: const Center(
        child: Text(
          'Contenido principal — material de clase, ejercicios y más',
          textAlign: TextAlign.center,
        ),
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
              leading: const Icon(Icons.verified_user_sharp),
              title: const Text("Login Test"),
              subtitle: const Text("Probar el login del usuario."),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
