import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/course.model.dart';

class ClassForm extends StatefulWidget {
  final Course? course;
  final Function(Course) onSubmit;

  const ClassForm({
    super.key,
    this.course,
    required this.onSubmit,
  });

  @override
  State<ClassForm> createState() => _ClassFormState();
}

class _ClassFormState extends State<ClassForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _coachController;
  late TextEditingController _descriptionController;
  late TextEditingController _capacityController;
  late TextEditingController _imageController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.course?.title);
    _coachController = TextEditingController(text: widget.course?.coach);
    _descriptionController = TextEditingController(text: widget.course?.description);
    _capacityController = TextEditingController(
        text: widget.course?.capacity.toString() ?? '10');

    _imageController = TextEditingController(text: widget.course?.image);

    final now = DateTime.now();
    _selectedDate = widget.course?.schedule ?? now;
    _selectedTime = TimeOfDay.fromDateTime(widget.course?.schedule ?? now);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Nouveau cours' : 'Modifier cours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre du cours'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _coachController,
                decoration: const InputDecoration(labelText: 'Nom du coach'),
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(labelText: 'Capacité'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Heure: ${_selectedTime.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final schedule = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final course = Course(
        id: widget.course?.id,
        title: _titleController.text,
        coach: _coachController.text,
        description: _descriptionController.text,
        schedule: schedule,
        capacity: int.parse(_capacityController.text),
        image: _imageController.text,
      );

      widget.onSubmit(course);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _coachController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}