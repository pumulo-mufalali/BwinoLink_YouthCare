import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final user = appState.currentUser;
        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppTheme.primaryPurple,
                            child: Text(
                              user.name.substring(0, 1).toUpperCase(),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.primaryPurple,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  user.phoneNumber,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.darkGrey.withOpacity(0.7),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: user.role == 'staff' 
                                        ? AppTheme.secondaryBlue 
                                        : user.role == 'peer_navigator'
                                        ? AppTheme.successGreen
                                        : AppTheme.accentPink,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.role == 'staff'
                                        ? 'Health Worker'
                                        : user.role == 'peer_navigator'
                                        ? 'Peer Navigator'
                                        : 'Youth',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.lightPurple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightPurple.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppTheme.primaryPurple,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.points} Points',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppTheme.primaryPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Earn more points by participating in health screenings',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.darkGrey.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Role Switching Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Switch User Role',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Experience the app from different perspectives:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => appState.switchUserRole('youth'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: user.role == 'youth'
                                    ? AppTheme.accentPink
                                    : AppTheme.lightGrey,
                                foregroundColor: user.role == 'youth'
                                    ? AppTheme.white 
                                    : AppTheme.darkGrey,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Youth'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => appState.switchUserRole('peer_navigator'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: user.role == 'peer_navigator'
                                    ? AppTheme.successGreen
                                    : AppTheme.lightGrey,
                                foregroundColor: user.role == 'peer_navigator'
                                    ? AppTheme.white
                                    : AppTheme.darkGrey,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Peer'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => appState.switchUserRole('staff'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: user.role == 'staff'
                                    ? AppTheme.secondaryBlue 
                                    : AppTheme.lightGrey,
                                foregroundColor: user.role == 'staff'
                                    ? AppTheme.white 
                                    : AppTheme.darkGrey,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Worker'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // App Settings Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Settings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        context,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Manage health reminders and updates',
                        onTap: () {
                          // TODO: Navigate to notifications settings
                        },
                      ),
                      const Divider(),
                      _buildSettingItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: 'Privacy & Security',
                        subtitle: 'Control your data and privacy settings',
                        onTap: () {
                          // TODO: Navigate to privacy settings
                        },
                      ),
                      const Divider(),
                      _buildSettingItem(
                        context,
                        icon: Icons.help,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        onTap: () {
                          // TODO: Navigate to help screen
                        },
                      ),
                      const Divider(),
                      _buildSettingItem(
                        context,
                        icon: Icons.info,
                        title: 'About BwinoLink YouthCare',
                        subtitle: 'App version and information',
                        onTap: () {
                          // TODO: Show about dialog
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    appState.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorRed,
                    foregroundColor: AppTheme.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Logout'),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryPurple,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.darkGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.darkGrey.withOpacity(0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.darkGrey.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }
}
