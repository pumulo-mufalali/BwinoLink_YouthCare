// Home tab for AfyaLink Market app
// Displays welcome message, health statistics, and quick actions

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'add_screening_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

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
              // Welcome section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppTheme.primaryGreen,
                            child: Text(
                              user.name.substring(0, 1).toUpperCase(),
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
                                  'Welcome back,',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.darkGrey.withOpacity(0.7),
                                  ),
                                ),
                                Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  user.role == 'champion' ? 'Health Champion' : 'Market Visitor',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.secondaryBlue,
                                    fontWeight: FontWeight.w500,
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
                          color: AppTheme.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.stars,
                              color: AppTheme.primaryGreen,
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
                                      color: AppTheme.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Keep earning points for health screenings',
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

              // Health statistics
              Text(
                'Health Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      'Total Screenings',
                      '${appState.totalScreeningsCount}',
                      Icons.medical_services,
                      AppTheme.primaryGreen,
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
              ),

              const SizedBox(height: 20),

              // Quick actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              if (user.role == 'staff') ...[
                _buildActionCard(
                  context,
                  'Add New Screening',
                  'Record health screening results',
                  Icons.add_circle,
                  AppTheme.primaryGreen,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddScreeningScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              _buildActionCard(
                context,
                'View All Results',
                'Check your health screening history',
                Icons.history,
                AppTheme.secondaryBlue,
                () => appState.setCurrentScreen(1), // Switch to Results tab
              ),

              const SizedBox(height: 12),

              _buildActionCard(
                context,
                'Redeem Rewards',
                'Use your points for health benefits',
                Icons.card_giftcard,
                AppTheme.accentGreen,
                () => appState.setCurrentScreen(2), // Switch to Rewards tab
              ),

              const SizedBox(height: 20),

              // Health tips
              Text(
                'Health Tips',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: AppTheme.warningOrange,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Daily Health Tip',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.darkGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Regular health screenings can help detect potential health issues early. '
                        'Visit your local health champion for a quick check-up!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Build statistics card
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
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

  // Build action card
  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.darkGrey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.darkGrey.withOpacity(0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
