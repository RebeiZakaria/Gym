import 'package:flutter/material.dart';
import '../screens/first_page.dart';
import 'admin_equipment_screen.dart';
import 'admin_classes_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tableau de bord administrateur'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fitness_center), text: 'Équipements'),
              Tab(icon: Icon(Icons.schedule), text: 'Cours'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FirstPage()),
              ),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            AdminEquipmentScreen(),
            AdminClassesScreen(),
          ],
        ),
      ),
    );
  }
}