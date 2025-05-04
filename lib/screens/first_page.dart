import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'equipment/equipment_list_screen.dart';
import 'package:gym_reservation_app/widgets/custom_button.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gym.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'GYM FIT PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'BIENVENUE CHEZ NOUS !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'SE CONNECTER',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "S'INSCRIRE",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

