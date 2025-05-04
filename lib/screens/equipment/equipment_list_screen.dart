import 'package:flutter/material.dart';
import 'package:gym_reservation_app/services/equipement.service.dart';
import 'package:gym_reservation_app/models/equipement.model.dart';
import 'equipment_detail_screen.dart';
import '../../widgets/custom_button.dart';

class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({super.key});

  @override
  State<EquipmentListScreen> createState() => _EquipmentListScreenState();
}

class _EquipmentListScreenState extends State<EquipmentListScreen> {
  final EquipmentService _equipmentService = EquipmentService();
  List<Equipment> _equipments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEquipments();
  }

  Future<void> _loadEquipments() async {
    setState(() => _isLoading = true);
    try {
      final data = await _equipmentService.fetchAllEquipments();
      setState(() => _equipments = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nos Équipements')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadEquipments,
        child: ListView.builder(
          itemCount: _equipments.length,
          itemBuilder: (context, index) {
            final equipment = _equipments[index];
            return EquipmentCard(
              equipment: equipment,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EquipmentDetailScreen(equipment: equipment),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final VoidCallback onPressed;

  const EquipmentCard({
    super.key,
    required this.equipment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              equipment.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(equipment.description ?? 'Pas de description disponible'),
            if (equipment.price > 0) ...[
              const SizedBox(height: 5),
              Text('Prix: ${equipment.price}€'),
            ],
            const SizedBox(height: 10),
            CustomButton(
              text: 'RÉSERVER',
              onPressed: onPressed,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}