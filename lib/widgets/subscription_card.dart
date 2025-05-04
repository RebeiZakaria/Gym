import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gym_reservation_app/providers/auth_provider.dart';
import '../../services/user_subscription.service.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final double price;
  final String period;
  final List<String> features;
  final Color color;
  final bool isPopular;
  final String planType;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.period,
    required this.features,
    required this.color,
    this.isPopular = false,
    required this.planType,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final idUser = "6806c6d8cca084de3d896cb7";
    final subscriptionService = UserSubscriptionService(client: http.Client());

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: isPopular
              ? Border.all(color: Colors.deepOrange, width: 2)
              : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'LE PLUS POPULAIRE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isPopular) const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: price.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: ' TND/$period',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: color, size: 20),
                    const SizedBox(width: 10),
                    Text(feature),
                  ],
                ),
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
                onPressed: () async {

                  try {
                    if (authProvider.user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez vous connecter')),
                      );
                      return;
                    }

                    final subscription = await subscriptionService.createSubscription(

                      userId: authProvider.user!.id!,
                      planType: planType,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Abonnement $title activé !')),
                    );

                    // Naviguer vers la page d'accueil ou de confirmation
                    Navigator.pushNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Souscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}