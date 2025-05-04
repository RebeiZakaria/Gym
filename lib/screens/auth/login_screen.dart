import 'package:flutter/material.dart';
import 'package:gym_reservation_app/models/user.model.dart';
import 'package:gym_reservation_app/widgets/custom_button.dart';
import 'package:gym_reservation_app/screens/auth/register_screen.dart';
import 'package:gym_reservation_app/screens/home_page.dart';
import 'package:gym_reservation_app/admin/admin_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/auth.service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(client: http.Client());
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (response != null) {
      final role = response['role'] ?? 'user';

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      setState(() => _errorMessage = 'Email ou mot de passe incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 30),
            CustomButton(
              text: 'SE CONNECTER',
                onPressed: () async {
                  final response = await _authService.login(
                    _emailController.text,
                    _passwordController.text,
                  );



                  if (response != null) {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);


                    // Créez l'objet User correctement
                    final user = User.fromJson({
                      'userId': response['user']["id"],
                      'email': _emailController.text,
                      'username': response['user']['username'] ?? _emailController.text.split('@').first,
                      'role': response['role'],
                      'token': response['token'],
                    });



                    authProvider.login(user, response['token']);

                    Navigator.pushReplacementNamed(
                      context,
                      user.role == 'admin' ? '/admin' : '/home',
                    );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}