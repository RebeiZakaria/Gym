import 'package:flutter/material.dart';
import 'package:gym_reservation_app/models/user.model.dart';
import 'package:gym_reservation_app/services/auth.service.dart';
import 'package:gym_reservation_app/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import '../../models/user.model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService(client: http.Client());
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    print('Début de l\'inscription'); // Debug

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final user = User(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    print('Envoi au serveur: ${user.toJson()}'); // Debug

    final res = await _authService.register(user).then(
            (error) {
          if (mounted) {
            setState(() {
              _errorMessage = error;
              if (error == null) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          }
        }).catchError((e) {
      print('Erreur: $e'); // Debug
      if (mounted) {
        setState(() => _errorMessage = 'Erreur: ${e.toString()}');
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });

    if (res != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);


      final usersigned = User.fromJson({
        'userId': res['user']["id"],
        'email': _emailController.text,
        'username': res['username'] ?? _emailController.text
            .split('@')
            .first,
        'role': res['role'],
        'token': res['token'],
      });


      authProvider.login(usersigned, res['token']);
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Inscription')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Nom d'utilisateur",
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Ce champ est obligatoire' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.isEmpty || !value.contains('@')
                      ? 'Email invalide'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) =>
                  value!.length < 6
                      ? 'Le mot de passe doit contenir au moins 6 caractères'
                      : null,
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
                  text: _isLoading ? 'Chargement...' : "S'INSCRIRE",
                  onPressed: _isLoading ? null : _submitForm,
                )
              ],
            ),
          ),
        ),
      );
    }
  }



