// Rewards tab for AfyaLink Market app
// Displays user points and available rewards for redemption

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final user = appState.currentUser;
        final availableRewards = appState.availableRewards;

        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Points summary card
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                                AppTheme.primaryPurple,
        AppTheme.accentPink,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stars,
                            color: AppTheme.white,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${user.points}',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Points',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Keep earning points by getting regular health screenings!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // How to earn points
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How to Earn Points',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildEarningMethod(
                        context,
                        'Health Screening',
                        'Get 50 points for each screening',
                        Icons.medical_services,
                        AppTheme.primaryPurple,
                      ),
                      const SizedBox(height: 12),
                      _buildEarningMethod(
                        context,
                        'Regular Check-ups',
                        'Earn 25 points for follow-up visits',
                        Icons.health_and_safety,
                        AppTheme.secondaryBlue,
                      ),
                      const SizedBox(height: 12),
                      _buildEarningMethod(
                        context,
                        'Health Tips Shared',
                        'Get 10 points for sharing health tips',
                        Icons.lightbulb,
                        AppTheme.accentPink,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Available rewards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Rewards',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.darkGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${availableRewards.length} Available',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rewards list
              if (availableRewards.isEmpty)
                _buildEmptyRewards(context)
              else
                ...availableRewards.map((reward) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildRewardCard(context, reward, user.points),
                )),

              const SizedBox(height: 24),

              // Coming soon rewards
              Text(
                'Coming Soon',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.lock,
                          color: AppTheme.darkGrey.withOpacity(0.5),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'More Rewards Coming',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Stay tuned for new health benefits and rewards',
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
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Build earning method
  Widget _buildEarningMethod(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
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
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.darkGrey.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build reward card
  Widget _buildRewardCard(BuildContext context, RewardItem reward, int userPoints) {
    final canAfford = userPoints >= reward.pointsRequired;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: canAfford 
                        ? AppTheme.primaryPurple.withOpacity(0.2)
                        : AppTheme.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.card_giftcard,
                    color: canAfford ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.5),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        reward.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: canAfford 
                            ? AppTheme.primaryPurple.withOpacity(0.2)
                            : AppTheme.lightGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${reward.pointsRequired} pts',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: canAfford ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (canAfford)
                      Text(
                        'Available',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.accentPink,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      Text(
                        'Need ${reward.pointsRequired - userPoints} more',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.5),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            if (canAfford) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _redeemReward(context, reward),
                  child: const Text('Redeem Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Build empty rewards state
  Widget _buildEmptyRewards(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.card_giftcard_outlined,
              size: 64,
              color: AppTheme.darkGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Rewards Available',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep earning points to unlock amazing health rewards!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.darkGrey.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Handle reward redemption
  void _redeemReward(BuildContext context, RewardItem reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Redeem Reward'),
        content: Text(
          'Are you sure you want to redeem "${reward.name}" for ${reward.pointsRequired} points?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showRedemptionSuccess(context, reward);
            },
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  // Show redemption success
  void _showRedemptionSuccess(BuildContext context, RewardItem reward) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully redeemed ${reward.name}!'),
        backgroundColor: AppTheme.accentPink,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          textColor: AppTheme.white,
          onPressed: () {
            // Could navigate to a redemption history screen
          },
        ),
      ),
    );
  }
}
