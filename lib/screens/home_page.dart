import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_reservation_app/providers/auth_provider.dart';
import 'package:gym_reservation_app/services/notification.service.dart';
import 'package:gym_reservation_app/screens/statistics.screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'chat.screen.dart';
import 'equipment/equipment_list_screen.dart';
import 'package:gym_reservation_app/widgets/custom_button.dart';
import 'notifications.screen.dart';
import 'subscription_page.dart';
import 'schedule_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasUnreadNotifications = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUnreadNotifications();
  }

  Future<void> _checkUnreadNotifications() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final notificationService = NotificationService(

    );

    try {
      if (authProvider.user?.id != null) {
        final hasUnread = await notificationService.hasUnreadNotifications(
          authProvider.user!.id,
        );
        setState(() {
          _hasUnreadNotifications = hasUnread;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error silently or show a snackbar if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GYM FIT PRO'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationsScreen(
                        userId: authProvider.user?.id,
                      ),
                    ),
                  );
                  // Refresh notification status after returning from notifications screen
                  _checkUnreadNotifications();
                },
              ),
              if (_hasUnreadNotifications && !_isLoading)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('gym.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'GYM FIT PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  'BIENVENUE CHEZ NOUS !',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'VOIR LES ÉQUIPEMENTS',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EquipmentListScreen()),
                  ),
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'NOS TARIFS',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SubscriptionPage()),
                  ),
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'VOIR LE PLANNING',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                  ),
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'VOIR STATISTIQUE',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                  ),
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ),
          // Floating Chat Button
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
              backgroundColor: Colors.deepPurple,
              child: const Icon(
                Icons.chat,
                color: Colors.white,
                size: 30,
              ),
              elevation: 8,
            ),
          ),
        ],
      ),
    );
  }
}