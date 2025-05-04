import 'package:flutter/material.dart';
import '../models/equipement.model.dart';

class EquipmentForm extends StatefulWidget {
  final Equipment? equipment;
  final Function(Equipment) onSubmit;

  const EquipmentForm({
    super.key,
    this.equipment,
    required this.onSubmit,
  });

  @override
  State<EquipmentForm> createState() => _EquipmentFormState();
}

class _EquipmentFormState extends State<EquipmentForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  late double _price;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    // Pré-remplir si en mode édition
    _name = widget.equipment?.name ?? '';
    _quantity = widget.equipment?.quantity ?? 1;
    _price = widget.equipment?.price ?? 0.0;
    _imageUrl = widget.equipment?.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.equipment == null ? 'Ajouter un équipement' : 'Modifier l\'équipement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantité'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: const InputDecoration(labelText: 'Prix (€)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
                onSaved: (value) => _price = double.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Enregistrer'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newEquipment = Equipment(
                      id: widget.equipment?.id,
                      name: _name,
                      quantity: _quantity,
                      price: _price,
                      image: _imageUrl,
                    );
                    widget.onSubmit(newEquipment);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
