import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.isYouth) {
          return _buildYouthDashboard(context, appState);
        } else if (appState.isStaff) {
          return _buildStaffDashboard(context, appState);
        } else if (appState.isPeerNavigator) {
          return _buildPeerNavigatorDashboard(context, appState);
        } else if (appState.isVendor) {
          return _buildVendorDashboard(context, appState);
        }
        return _buildDefaultDashboard(context, appState);
      },
    );
  }

  // Youth Dashboard
  Widget _buildYouthDashboard(BuildContext context, AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(context, appState),
          const SizedBox(height: 24),

          // Quick actions
          _buildQuickActions(context, appState),
          const SizedBox(height: 24),

          // Health access points
          _buildHealthAccessPoints(context, appState),
          const SizedBox(height: 24),

          // Peer navigator section
          if (appState.peerNavigatorAssignment != null)
            _buildPeerNavigatorSection(context, appState),
          if (appState.peerNavigatorAssignment != null)
            const SizedBox(height: 24),

          // Recent screenings
          _buildRecentScreenings(context, appState),
          const SizedBox(height: 24),

          // Achievements
          _buildAchievementsSection(context, appState),
        ],
      ),
    );
  }

  // Staff Dashboard
  Widget _buildStaffDashboard(BuildContext context, AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(context, appState),
          const SizedBox(height: 24),

          // Statistics cards
          _buildStatisticsCards(context, appState),
          const SizedBox(height: 24),

          // Quick actions
          _buildStaffQuickActions(context, appState),
          const SizedBox(height: 24),

          // Recent screenings
          _buildRecentScreenings(context, appState),
          const SizedBox(height: 24),

          // Health access points
          _buildHealthAccessPoints(context, appState),
        ],
      ),
    );
  }

  // Peer Navigator Dashboard
  Widget _buildPeerNavigatorDashboard(BuildContext context, AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(context, appState),
          const SizedBox(height: 24),

          // Assigned youth
          _buildAssignedYouthSection(context, appState),
          const SizedBox(height: 24),

          // Quick actions
          _buildPeerNavigatorQuickActions(context, appState),
          const SizedBox(height: 24),

          // View full dashboard button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/peer-navigator');
              },
              icon: const Icon(Icons.dashboard),
              label: const Text('View Full Dashboard'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent screenings
          _buildRecentScreenings(context, appState),
        ],
      ),
    );
  }

  // Vendor Dashboard
  Widget _buildVendorDashboard(BuildContext context, AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(context, appState),
          const SizedBox(height: 24),

          // Market health services
          _buildMarketHealthServices(context, appState),
          const SizedBox(height: 24),

          // Recent screenings at market
          _buildRecentScreenings(context, appState),
        ],
      ),
    );
  }

  // Default Dashboard
  Widget _buildDefaultDashboard(BuildContext context, AppState appState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(context, appState),
          const SizedBox(height: 24),
          _buildRecentScreenings(context, appState),
        ],
      ),
    );
  }

  // Welcome Section
  Widget _buildWelcomeSection(BuildContext context, AppState appState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryPurple,
                  child: Text(
                    appState.currentUser?.name.substring(0, 1) ?? 'U',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                        'Welcome back, ${appState.currentUser?.name ?? 'User'}!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your health journey continues',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Points',
                    '${appState.currentUser?.points ?? 0}',
                    Icons.stars,
                    AppTheme.accentPink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Screenings',
                    '${appState.totalScreeningsCount}',
                    Icons.medical_services,
                    AppTheme.secondaryBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Quick Actions for Youth
  Widget _buildQuickActions(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Find Health Services',
                Icons.location_on,
                AppTheme.primaryPurple,
                () {
                  Navigator.pushNamed(context, '/health-access-points');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Book Appointment',
                Icons.calendar_today,
                AppTheme.secondaryBlue,
                () {
                  // Navigate to booking
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment booking coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'USSD Access',
                Icons.phone_android,
                AppTheme.accentPink,
                () {
                  // Show USSD instructions
                  _showUSSDDialog(context);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Health Tips',
                Icons.lightbulb,
                AppTheme.successGreen,
                () {
                  // Navigate to health tips
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Health tips coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Staff Quick Actions
  Widget _buildStaffQuickActions(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Add Screening',
                Icons.add,
                AppTheme.primaryPurple,
                () {
                  Navigator.pushNamed(context, '/add-screening');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'View Reports',
                Icons.analytics,
                AppTheme.secondaryBlue,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reports coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Peer Navigator Quick Actions
  Widget _buildPeerNavigatorQuickActions(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Record Health',
                Icons.add,
                AppTheme.primaryPurple,
                () {
                  Navigator.pushNamed(context, '/add-screening');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                'Contact Youth',
                Icons.message,
                AppTheme.secondaryBlue,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Messaging coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Health Access Points
  Widget _buildHealthAccessPoints(BuildContext context, AppState appState) {
    final accessPoints = appState.getNearbyAccessPoints();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Access Points',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...accessPoints.map((point) => _buildAccessPointCard(context, point)),
      ],
    );
  }

  // Market Health Services
  Widget _buildMarketHealthServices(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Health Services',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.store, color: AppTheme.successGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Lusaka Central Market',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Available Services:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    'Blood Pressure',
                    'Blood Sugar',
                    'HIV Self-Test',
                    'BMI',
                  ].map((service) => Chip(
                    label: Text(service),
                    backgroundColor: AppTheme.lightPurple.withOpacity(0.2),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  'Hours: Mon-Fri 8:00 AM - 4:00 PM',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Peer Navigator Section
  Widget _buildPeerNavigatorSection(BuildContext context, AppState appState) {
    final assignment = appState.peerNavigatorAssignment;
    if (assignment == null) return const SizedBox.shrink();

    final peerNavigator = DummyData.users.firstWhere(
      (user) => user.phoneNumber == assignment.peerNavigatorId,
      orElse: () => DummyData.users.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Peer Navigator',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppTheme.primaryPurple,
                  child: Text(
                    peerNavigator.name.substring(0, 1),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                        peerNavigator.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Peer Navigator',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: assignment.supportAreas.map((area) => Chip(
                          label: Text(area.replaceAll('_', ' ')),
                          backgroundColor: AppTheme.lightPurple.withOpacity(0.2),
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                        )).toList(),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacting peer navigator...')),
                    );
                  },
                  icon: Icon(Icons.message, color: AppTheme.primaryPurple),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Assigned Youth Section
  Widget _buildAssignedYouthSection(BuildContext context, AppState appState) {
    final assignedYouth = DummyData.users.where((user) => 
      user.role == 'youth' && 
      DummyData.getPeerNavigatorAssignment(user.phoneNumber)?.peerNavigatorId == appState.currentUser?.phoneNumber
    ).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assigned Youth (${assignedYouth.length})',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...assignedYouth.map((youth) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.accentPink,
              child: Text(
                youth.name.substring(0, 1),
                style: const TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(youth.name),
            subtitle: Text('${youth.age} years • ${youth.location}'),
            trailing: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Contacting ${youth.name}...')),
                );
              },
              icon: Icon(Icons.message, color: AppTheme.primaryPurple),
            ),
          ),
        )),
      ],
    );
  }

  // Statistics Cards
  Widget _buildStatisticsCards(BuildContext context, AppState appState) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Total Screenings',
            '${appState.totalScreeningsCount}',
            Icons.medical_services,
            AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Abnormal Results',
            '${appState.abnormalResultsCount}',
            Icons.warning,
            AppTheme.warningOrange,
          ),
        ),
      ],
    );
  }

  // Recent Screenings
  Widget _buildRecentScreenings(BuildContext context, AppState appState) {
    final recentScreenings = appState.userScreenings.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Screenings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (recentScreenings.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: 48,
                      color: AppTheme.darkGrey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No screenings yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.darkGrey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...recentScreenings.map((screening) => _buildScreeningCard(context, screening)),
      ],
    );
  }

  // Achievements Section
  Widget _buildAchievementsSection(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gamification');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: appState.userAchievements.length,
          itemBuilder: (context, index) {
            final achievement = appState.userAchievements[index];
            return _buildAchievementCard(context, achievement);
          },
        ),
      ],
    );
  }

  // Helper Widgets
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessPointCard(BuildContext context, HealthAccessPoint point) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAccessPointColor(point.type),
          child: Icon(_getAccessPointIcon(point.type), color: AppTheme.white),
        ),
        title: Text(point.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(point.location),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: point.services.take(3).map((service) => Chip(
                label: Text(service),
                backgroundColor: AppTheme.lightPurple.withOpacity(0.2),
                labelStyle: Theme.of(context).textTheme.bodySmall,
              )).toList(),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Contacting ${point.name}...')),
            );
          },
          icon: Icon(Icons.phone, color: AppTheme.primaryPurple),
        ),
      ),
    );
  }

  Widget _buildScreeningCard(BuildContext context, ScreeningResult screening) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(screening.status),
          child: Icon(_getStatusIcon(screening.status), color: AppTheme.white),
        ),
        title: Text(screening.testType),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Result: ${screening.result}'),
            Text('Date: ${_formatDate(screening.date)}'),
            if (screening.location != 'clinic')
              Text('Location: ${screening.location.replaceAll('_', ' ')}'),
          ],
        ),
        trailing: _getStatusChip(screening.status),
      ),
    );
  }

  Widget _buildAchievementCard(BuildContext context, Achievement achievement) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${achievement.pointsRewarded} pts',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.accentPink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getAccessPointColor(String type) {
    switch (type) {
      case 'market':
        return AppTheme.successGreen;
      case 'youth_center':
        return AppTheme.accentPink;
      case 'clinic':
        return AppTheme.secondaryBlue;
      default:
        return AppTheme.primaryPurple;
    }
  }

  IconData _getAccessPointIcon(String type) {
    switch (type) {
      case 'market':
        return Icons.store;
      case 'youth_center':
        return Icons.people;
      case 'clinic':
        return Icons.local_hospital;
      default:
        return Icons.location_on;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'normal':
        return AppTheme.successGreen;
      case 'abnormal':
        return AppTheme.errorRed;
      case 'follow_up_needed':
        return AppTheme.warningOrange;
      default:
        return AppTheme.darkGrey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'normal':
        return Icons.check;
      case 'abnormal':
        return Icons.warning;
      case 'follow_up_needed':
        return Icons.schedule;
      default:
        return Icons.help;
    }
  }

  Widget _getStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'normal':
        color = AppTheme.successGreen;
        label = 'Normal';
        break;
      case 'abnormal':
        color = AppTheme.errorRed;
        label = 'Abnormal';
        break;
      case 'follow_up_needed':
        color = AppTheme.warningOrange;
        label = 'Follow-up';
        break;
      default:
        color = AppTheme.darkGrey;
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showUSSDDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('USSD Access'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dial *123# to access:'),
            const SizedBox(height: 12),
            const Text('• Health results'),
            const Text('• Book appointments'),
            const Text('• Redeem vouchers'),
            const Text('• Get health tips'),
            const SizedBox(height: 12),
            const Text('Works on all phones!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
