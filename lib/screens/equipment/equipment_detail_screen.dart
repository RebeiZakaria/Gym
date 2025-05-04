import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/equipement.model.dart';
import '../../services/EquipmentPurchase.service.dart';
import '../../models/EquipmentPurchase.model.dart';
import '../../widgets/custom_button.dart';
import '../../providers/auth_provider.dart';

class EquipmentDetailScreen extends StatefulWidget {


  final Equipment equipment;


  const EquipmentDetailScreen({
    super.key,
    required this.equipment,
  });

  @override
  State<EquipmentDetailScreen> createState() => _EquipmentDetailScreenState();
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {

  final EquipmentPurchaseService equipementpurchaseservice = EquipmentPurchaseService(client: http.Client());
  int _quantity = 1;
  bool _isLoading = false;

  Future<void> _confirmPurchase(BuildContext context) async {
    setState(() => _isLoading = true);


      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      final token = authProvider.token;

      if (userId == null || token == null) {
        throw Exception('User not authenticated');
      }

      // Call your existing purchase endpoint

    try{

   final response = await equipementpurchaseservice.createPurchase(userId: userId,
          equipmentId: widget.equipment.id,
          quantity: _quantity,
          token: token);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Achat confirmé avec succès!')),
      );
      Navigator.pop(context);
    } else {
      throw Exception('Failed to confirm purchase');
    }
  } catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Erreur: ${e.toString()}')),
  );
  } finally {
  setState(() => _isLoading = false);
  }
      }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.equipment.name)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... existing image and description code ...


                 Image.network(
              widget.equipment.image!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,

            ),
            if (widget.equipment.quantity != null) ...[
              const SizedBox(height: 20),
              Text(
                'Quantité disponible: ${widget.equipment.quantity}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Text('Quantité:'),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _quantity,
                    items: List.generate(widget.equipment.quantity!, (index) => index + 1)
                        .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _quantity = value);
                      }
                    },
                  ),
                ],
              ),
            ],

            const Spacer(),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
              text: 'CONFIRMER L\'ACHAT',
              onPressed: () => _confirmPurchase(context),
            ),
          ],
        ),
      ),
    );
  }
}