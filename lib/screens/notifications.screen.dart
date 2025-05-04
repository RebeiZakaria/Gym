import 'package:flutter/material.dart';
import 'package:gym_reservation_app/models/notification.model.dart';
import 'package:gym_reservation_app/services/notification.service.dart';

class NotificationsScreen extends StatefulWidget {
  final String? userId;

  const NotificationsScreen({super.key, required this.userId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {

      final notifications = await _notificationService.getUserNotifications(widget.userId);
      setState(() {
        _notifications = notifications;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(read: true);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as read: $e')),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead(widget.userId);
      setState(() {
        _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All notifications marked as read')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark all as read: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return const Center(child: Text('No notifications yet'));
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(color: Colors.red),
      secondaryBackground: Container(color: Colors.green),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe left to delete (you'll need to implement deletion in your service)
          return false; // Change to true when you implement deletion
        } else {
          // Swipe right to mark as read if unread
          if (!notification.read) {
            await _markAsRead(notification.id);
          }
          return false;
        }
      },
      child: Card(
        color: notification.read ? Colors.grey[200] : Colors.blue[50],
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: _getNotificationIcon(notification.type),
          title: Text(notification.title),
          subtitle: Text(notification.message),
          trailing: Text(
            _formatDate(notification.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () {
            if (!notification.read) {
              _markAsRead(notification.id);
            }
            // Add navigation to relevant screen based on notification type
          },
        ),
      ),
    );
  }

  Widget _getNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.created:
        icon = Icons.add_circle;
        color = Colors.green;
        break;
      case NotificationType.updated:
        icon = Icons.edit;
        color = Colors.blue;
        break;
      case NotificationType.cancelled:
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case NotificationType.reminder:
        icon = Icons.notifications_active;
        color = Colors.orange;
        break;
    }

    return Icon(icon, color: color);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Add this extension to your NotificationModel class
extension NotificationModelExtension on NotificationModel {
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? reservationId,
    NotificationType? type,
    String? title,
    String? message,
    bool? read,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      reservationId: reservationId ?? this.reservationId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      read: read ?? this.read,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}