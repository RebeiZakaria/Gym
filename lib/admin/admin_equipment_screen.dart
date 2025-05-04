import 'package:flutter/material.dart';
import '../models/equipement.model.dart';
import '../services/equipement.service.dart';
import 'equipment_form.dart';

class AdminEquipmentScreen extends StatefulWidget {
  const AdminEquipmentScreen({super.key});

  @override
  State<AdminEquipmentScreen> createState() => _AdminEquipmentScreenState();
}

class _AdminEquipmentScreenState extends State<AdminEquipmentScreen> {
  final EquipmentService equipmentService = EquipmentService();
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
      final data = await equipmentService.fetchAllEquipments();
      setState(() => _equipments = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAddEquipment(Equipment newEquipment) async {
    try {
      await equipmentService.addEquipment(newEquipment);
      await _loadEquipments(); // Recharge la liste mise à jour
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Équipement ajouté avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleUpdateEquipment(String id, Equipment updatedEquipment) async {
    try {
      await equipmentService.updateEquipment(id, updatedEquipment);
      await _loadEquipments();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Équipement modifié avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleDeleteEquipment(String id) async {
    try {
      await equipmentService.deleteEquipment(id);
      await _loadEquipments();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Équipement supprimé avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des Équipements')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EquipmentForm(onSubmit: _handleAddEquipment),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _equipments.length,
        itemBuilder: (context, index) {
          final equipment = _equipments[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.fitness_center),
              title: Text(equipment.name),
              subtitle: Text('Quantité: ${equipment.quantity} | Prix: ${equipment.price}€'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EquipmentForm(
                          equipment: equipment,
                          onSubmit: (updated) =>
                              _handleUpdateEquipment(equipment.id!, updated),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _handleDeleteEquipment(equipment.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}