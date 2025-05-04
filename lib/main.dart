import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_reservation_app/providers/auth_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gym_reservation_app/providers/auth_provider.dart';
import 'package:gym_reservation_app/screens/auth/login_screen.dart';
import 'package:gym_reservation_app/screens/auth/register_screen.dart';
import 'package:gym_reservation_app/screens/first_page.dart';
import 'package:gym_reservation_app/screens/home_page.dart';
import 'package:gym_reservation_app/screens/subscription_page.dart';
import 'package:gym_reservation_app/admin/admin_dashboard.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // Ajoutez d'autres providers ici si nécessaire
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym Reservation',

      // Configuration du thème
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),

      // Configuration des routes
      routes: {
        '/': (context) => const FirstPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/subscriptions': (context) => const SubscriptionPage(),
        '/admin': (context) => const AdminDashboard(),
      },

      // Localisation
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      locale: const Locale('fr', 'FR'),

      // Gestion des routes non définies
      onGenerateRoute: (settings) {
        // Vous pouvez ajouter une logique pour des routes dynamiques ici
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page non trouvée')),
          ),
        );
      },
    );
  }
}