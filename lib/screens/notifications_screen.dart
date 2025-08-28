import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_state.dart';
import '../data/dummy_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final notifications = appState.userNotifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () => _markAllAsRead(context, appState),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationsList(notifications, appState),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppTheme.lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.darkGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll see important updates here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationItem> notifications, AppState appState) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, appState);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification, AppState appState) {
    final isUnread = !notification.isRead;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isUnread ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isUnread 
            ? BorderSide(color: AppTheme.primaryPurple, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification, appState),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(notification.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                              color: isUnread ? AppTheme.darkGrey : AppTheme.darkGrey,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppTheme.darkGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case 'screening_result':
        iconData = Icons.medical_services;
        iconColor = AppTheme.primaryPurple;
        break;
      case 'appointment':
        iconData = Icons.calendar_today;
        iconColor = AppTheme.secondaryBlue;
        break;
      case 'reminder':
        iconData = Icons.alarm;
        iconColor = AppTheme.warningOrange;
        break;
      case 'achievement':
        iconData = Icons.emoji_events;
        iconColor = AppTheme.warningOrange;
        break;
      case 'message':
        iconData = Icons.message;
        iconColor = AppTheme.successGreen;
        break;
      case 'assignment':
        iconData = Icons.person_add;
        iconColor = AppTheme.accentPink;
        break;
      case 'follow_up':
        iconData = Icons.schedule;
        iconColor = AppTheme.errorRed;
        break;
      case 'abnormal_result':
        iconData = Icons.warning;
        iconColor = AppTheme.errorRed;
        break;
      case 'summary':
        iconData = Icons.analytics;
        iconColor = AppTheme.secondaryBlue;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.lightGrey;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _handleNotificationTap(NotificationItem notification, AppState appState) {
    // Mark as read
    appState.markNotificationAsRead(notification.id);

    // Handle different notification actions
    switch (notification.action) {
      case 'view_result':
        Navigator.pushNamed(context, '/results-tab');
        break;
      case 'view_appointment':
        // Navigate to appointments screen (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointments coming soon!')),
        );
        break;
      case 'view_achievement':
        Navigator.pushNamed(context, '/gamification');
        break;
      case 'open_chat':
        Navigator.pushNamed(context, '/health-worker-chat');
        break;
      case 'view_tip':
        Navigator.pushNamed(context, '/health-tips');
        break;
      case 'view_youth_profile':
        // Navigate to youth profile (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Youth profile coming soon!')),
        );
        break;
      case 'view_screening_result':
        Navigator.pushNamed(context, '/results-tab');
        break;
      case 'schedule_follow_up':
        // Navigate to follow-up scheduling (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Follow-up scheduling coming soon!')),
        );
        break;
      case 'open_youth_chat':
        Navigator.pushNamed(context, '/peer-chat');
        break;
      case 'submit_report':
        // Navigate to report submission (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submission coming soon!')),
        );
        break;
      case 'review_screening':
        Navigator.pushNamed(context, '/results-tab');
        break;
      case 'review_abnormal_result':
        Navigator.pushNamed(context, '/results-tab');
        break;
      case 'view_summary':
        // Navigate to summary view (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Summary view coming soon!')),
        );
        break;
      case 'schedule_maintenance':
        // Navigate to maintenance scheduling (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maintenance scheduling coming soon!')),
        );
        break;
      default:
        // Do nothing
        break;
    }
  }

  void _markAllAsRead(BuildContext context, AppState appState) {
    appState.markAllNotificationsAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}
