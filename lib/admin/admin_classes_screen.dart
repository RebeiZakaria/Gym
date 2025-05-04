import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/course.model.dart';
import '../services/course.service.dart';
import 'class_form.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({super.key});

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen> {
  final CourseService _courseService = CourseService(client: http.Client());
  List<Course> _courses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      final data = await _courseService.fetchAllCourses();
      setState(() => _courses = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAddCourse(Course newCourse) async {
    try {
      await _courseService.createCourse(newCourse);
      await _loadCourses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cours ajouté avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleUpdateCourse(String id, Course updatedCourse) async {
    try {
      await _courseService.updateCourse(id, updatedCourse);
      await _loadCourses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cours modifié avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleDeleteCourse(String id) async {
    try {
      await _courseService.deleteCourse(id);
      await _loadCourses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cours supprimé avec succès!')),
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
      appBar: AppBar(title: const Text('Gestion des Cours')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClassForm(onSubmit: _handleAddCourse),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadCourses,
        child: ListView.builder(
          itemCount: _courses.length,
          itemBuilder: (context, index) {
            final course = _courses[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: course.image != null
                    ? Image.network(course.image!, width: 50, height: 50)
                    : const Icon(Icons.group),
                title: Text(course.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Coach: ${course.coach}'),
                    Text('Horaire: ${course.formattedSchedule}'),
                    Text('Capacité: ${course.capacity} places'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClassForm(
                            course: course,
                            onSubmit: (updated) =>
                                _handleUpdateCourse(course.id!, updated),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _handleDeleteCourse(course.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}