import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class PeerNavigatorScreen extends StatefulWidget {
  const PeerNavigatorScreen({super.key});

  @override
  State<PeerNavigatorScreen> createState() => _PeerNavigatorScreenState();
}

class _PeerNavigatorScreenState extends State<PeerNavigatorScreen> {
  String _selectedTab = 'assigned';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Navigator'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final user = appState.currentUser;
          if (user == null || !appState.isPeerNavigator) {
            return const Center(
              child: Text('Access denied. Peer navigator role required.'),
            );
          }

          final assignments = appState.peerNavigatorAssignment;
          final assignedYouth = assignments != null 
              ? DummyData.users.where((u) => u.phoneNumber == assignments.youthId).toList()
              : <UserProfile>[];

          return Column(
            children: [
              // Header Stats
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppTheme.white.withOpacity(0.2),
                          child: Icon(
                            Icons.people,
                            color: AppTheme.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Peer Navigator',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Assigned Youth',
                            assignedYouth.length.toString(),
                            Icons.person,
                            AppTheme.accentPink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Active Cases',
                            assignments?.status == 'active' ? '1' : '0',
                            Icons.assignment,
                            AppTheme.secondaryBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Support Areas',
                            assignments?.supportAreas.length.toString() ?? '0',
                            Icons.psychology,
                            AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tab Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton('assigned', 'Assigned Youth', Icons.people),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton('resources', 'Resources', Icons.book),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton('reports', 'Reports', Icons.assessment),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _buildTabContent(assignedYouth, assignments),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab, String label, IconData icon) {
    final isSelected = _selectedTab == tab;
    return InkWell(
      onTap: () => setState(() => _selectedTab = tab),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.white : AppTheme.darkGrey,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isSelected ? AppTheme.white : AppTheme.darkGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(List<UserProfile> assignedYouth, PeerNavigatorAssignment? assignment) {
    switch (_selectedTab) {
      case 'assigned':
        return _buildAssignedYouthTab(assignedYouth, assignment);
      case 'resources':
        return _buildResourcesTab();
      case 'reports':
        return _buildReportsTab(assignedYouth, assignment);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAssignedYouthTab(List<UserProfile> assignedYouth, PeerNavigatorAssignment? assignment) {
    if (assignedYouth.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppTheme.darkGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No youth assigned yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Youth will be automatically assigned based on needs',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assignedYouth.length,
      itemBuilder: (context, index) {
        final youth = assignedYouth[index];
        return _buildYouthCard(youth, assignment);
      },
    );
  }

  Widget _buildYouthCard(UserProfile youth, PeerNavigatorAssignment? assignment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppTheme.primaryPurple.withOpacity(0.2),
                  child: Text(
                    youth.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        youth.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Age: ${youth.age} • ${youth.location}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: assignment?.status == 'active' 
                        ? AppTheme.successGreen.withOpacity(0.2)
                        : AppTheme.warningOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    assignment?.status ?? 'pending',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: assignment?.status == 'active' 
                          ? AppTheme.successGreen 
                          : AppTheme.warningOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            if (assignment != null) ...[
              const SizedBox(height: 12),
              Text(
                'Support Areas:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppTheme.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: assignment.supportAreas.map((area) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      area.replaceAll('_', ' ').toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              if (assignment.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes:',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.secondaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        assignment.notes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showContactDialog(youth),
                    icon: const Icon(Icons.message),
                    label: const Text('Contact'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryPurple,
                      side: BorderSide(color: AppTheme.primaryPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showHealthRecordDialog(youth),
                    icon: const Icon(Icons.health_and_safety),
                    label: const Text('Health Record'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesTab() {
    final resources = [
      {
        'title': 'Mental Health Support',
        'description': 'Resources for supporting youth mental health',
        'icon': Icons.psychology,
        'color': AppTheme.accentPink,
      },
      {
        'title': 'Sexual Health Education',
        'description': 'Materials for sexual health counseling',
        'icon': Icons.favorite,
        'color': AppTheme.primaryPurple,
      },
      {
        'title': 'Crisis Intervention',
        'description': 'Emergency protocols and contacts',
        'icon': Icons.emergency,
        'color': AppTheme.errorRed,
      },
      {
        'title': 'Peer Support Training',
        'description': 'Training materials for peer navigators',
        'icon': Icons.school,
        'color': AppTheme.secondaryBlue,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (resource['color'] as Color).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                resource['icon'] as IconData,
                color: resource['color'] as Color,
                size: 24,
              ),
            ),
            title: Text(
              resource['title'] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.darkGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              resource['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.7),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.darkGrey.withOpacity(0.4),
              size: 16,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${resource['title']} resources coming soon!'),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReportsTab(List<UserProfile> assignedYouth, PeerNavigatorAssignment? assignment) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Report',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReportItem('Youth Assisted', assignedYouth.length.toString()),
                _buildReportItem('Active Cases', assignment?.status == 'active' ? '1' : '0'),
                _buildReportItem('Support Sessions', '12'),
                _buildReportItem('Referrals Made', '3'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Report download feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      foregroundColor: AppTheme.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReportItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkGrey.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(UserProfile youth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${youth.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: AppTheme.primaryPurple),
              title: const Text('Call'),
              subtitle: Text(youth.phoneNumber),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Call feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: AppTheme.primaryPurple),
              title: const Text('Send SMS'),
              subtitle: const Text('Send a supportive message'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('SMS feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.video_call, color: AppTheme.primaryPurple),
              title: const Text('Video Call'),
              subtitle: const Text('Schedule a video session'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Video call feature coming soon!')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showHealthRecordDialog(UserProfile youth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${youth.name}\'s Record'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Health record feature coming soon!'),
            SizedBox(height: 8),
            Text('This will show the youth\'s health history, screenings, and follow-up needs.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
