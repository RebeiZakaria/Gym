import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/course.model.dart';
import '../providers/auth_provider.dart';
import '../services/course.service.dart';
import 'package:http/http.dart' as http;

import '../services/reservation.service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  ReservationService reservationService = ReservationService(client:http.Client());
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Course>> _events = {};
  bool _isLoading = false;
  final CourseService _courseService = CourseService(client: http.Client());

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => _isLoading = true);
    try {
      final courses = await _courseService.getFutureCourses();
      _processCourses(courses);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _processCourses(List<Course> courses) {
    final events = <DateTime, List<Course>>{};

    for (final course in courses) {
      final dateKey = DateTime.utc(
        course.schedule.year,
        course.schedule.month,
        course.schedule.day,
      );

      events[dateKey] = [...events[dateKey] ?? [], course];
    }

    setState(() => _events = events);
  }

  String _formatTime(DateTime time) {
    return DateFormat.Hm('fr').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning de la Salle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCourses,
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () => setState(() {
              _focusedDay = DateTime.now();
              _selectedDay = null;
            }),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            TableCalendar<Course>(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              eventLoader: (day) => _events[day] ?? [],
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _selectedDay == null
                  ? _buildWeeklyEvents()
                  : _buildDailyEvents(_selectedDay!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyEvents() {
    final weekStart = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    final weekCourses = <Course>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final normalizedDay = DateTime.utc(day.year, day.month, day.day);
      weekCourses.addAll(_events[normalizedDay] ?? []);
    }

    return weekCourses.isEmpty
        ? const Center(child: Text('Aucun cours cette semaine'))
        : ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: weekCourses.length,
      itemBuilder: (context, index) {
        return _buildCourseItem(weekCourses[index]);
      },
    );
  }

  Widget _buildDailyEvents(DateTime day) {
    final normalizedDay = DateTime.utc(day.year, day.month, day.day);
    final courses = _events[normalizedDay] ?? [];

    return courses.isEmpty
        ? const Center(child: Text('Aucun cours ce jour'))
        : ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _buildCourseItem(courses[index]);
      },
    );
  }

  Widget _buildCourseItem(Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 50,
            minHeight: 50,
            maxWidth: 50,
            maxHeight: 50,
          ),
          child: course.image != null && course.image!.isNotEmpty
              ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              course.image!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
            ),
          )
              : const Icon(Icons.fitness_center, size: 30),
        ),
        title: Text(
          course.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coach: ${course.coach}'),
            Text('${_formatTime(course.schedule)} - ${course.capacity} places'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showCourseDetails(course),
        ),
      ),
    );
  }

  void _showCourseDetails(Course course) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(course.title),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (course.image != null && course.image!.isNotEmpty)
                    AspectRatio(
                      aspectRatio: 16/9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          course.image!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Coach: ${course.coach}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Date: ${DateFormat.yMMMMd('fr').format(course.schedule)}'),
                  Text('Heure: ${_formatTime(course.schedule)}'),
                  Text('Capacité: ${course.capacity} places'),
                  const SizedBox(height: 16),
                  Text(
                    course.description ?? 'Pas de description disponible',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Fermer'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Réserver'),
              onPressed: () {
                Navigator.of(context).pop();
                _reserveCourse(course);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _reserveCourse(Course course) async {
    try {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      final token = authProvider.token;

      if (userId == null || token == null) {
        throw Exception('User not authenticated');
      }

      final reservation = await reservationService.createReservation(
        userId: userId,
        courseId: course.id,
        sessionDate: course.schedule,
        token: token,
      );

      if (reservation != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réservation pour ${course.title} confirmée!')),
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}