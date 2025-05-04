import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/subscription.service.dart';
import '../models/subscription_plan.model.dart';
import '../widgets/subscription_card.dart';
import 'package:http/http.dart' as http;

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final SubscriptionService _subscriptionService = SubscriptionService(client: http.Client());
  late Future<List<SubscriptionPlan>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _plansFuture = _subscriptionService.getPlans();
  }

  // Ajoutez cette méthode
  String _getDisplayTitle(String planType) {
    switch (planType) {
      case 'monthly': return '1 MOIS';
      case 'quarterly': return '3 MOIS';
      case 'semi-annual': return '6 MOIS';
      case 'annual': return '12 MOIS';
      default: return planType.toUpperCase();
    }
  }

  // Ajoutez aussi ces autres méthodes nécessaires
  String _getPeriodText(String planType) {
    switch (planType) {
      case 'monthly': return 'pour 1 mois';
      case 'quarterly': return 'par trimestre';
      case 'semi-annual': return 'par semestre';
      case 'annual': return 'par an';
      default: return '';
    }
  }

  Color _getPlanColor(String planType) {
    switch (planType) {
      case 'monthly': return Colors.blue;
      case 'quarterly': return Colors.deepPurple;
      case 'semi-annual': return Colors.orange;
      case 'annual': return Colors.green;
      default: return Colors.grey;
    }
  }

  List<String> _getFeatures(SubscriptionPlan plan) {
    switch (plan.planType) {
      case 'monthly':
        return [
          "Accès illimité 7j/7",
          "Tous les équipements",
          "Cours collectifs inclus"
        ];
      case 'quarterly':
        return [
          "Économisez 10%",
          "Accès illimité 7j/7",
          "Cours illimités + 1 séance sauna"
        ];
      case 'semi-annual':
        return [
          "Économisez 20%",
          "Accès 24h/24",
          "2 séances massage offertes"
        ];
      case 'annual':
        return [
          "Économisez 30%",
          "Coach personnel 1h/mois",
          "Accès VIP à tous les services"
        ];
      default: return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABONNEMENTS'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SubscriptionPlan>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun abonnement disponible'));
          }

          final plans = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    /*image: DecorationImage(
                      image: AssetImage('assets/images/gym_banner.jpg'),
                      fit: BoxFit.cover,
                    ),*/
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CHOISISSEZ VOTRE DURÉE',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Bénéficiez de tarifs dégressifs selon la durée choisie',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),

                      ...plans.map((plan) {
                        return Column(
                          children: [
                            SubscriptionCard(
                              title: _getDisplayTitle(plan.planType), // Maintenant valide
                              price: plan.price,
                              period: _getPeriodText(plan.planType),
                              features: _getFeatures(plan),
                              color: _getPlanColor(plan.planType),
                              isPopular: plan.planType == 'quarterly',
                              planType: plan.planType,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),

                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.help_outline),
                            label: const Text('COMPARER LES OFFRES'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                            onPressed: () {
                              // Navigation vers comparaison
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}