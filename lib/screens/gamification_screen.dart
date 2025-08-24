import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class GamificationScreen extends StatefulWidget {
  const GamificationScreen({super.key});

  @override
  State<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends State<GamificationScreen> {
  String _selectedTab = 'achievements';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamification'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final user = appState.currentUser;
          if (user == null) return const SizedBox.shrink();

          return Column(
            children: [
              // Points Header
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
                        const SizedBox(width: 8),
                        Text(
                          'Points',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Keep earning points by participating in health activities!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
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
                      child: _buildTabButton('achievements', 'Achievements', Icons.emoji_events),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton('rewards', 'Rewards', Icons.card_giftcard),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTabButton('leaderboard', 'Leaderboard', Icons.leaderboard),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _buildTabContent(user),
              ),
            ],
          );
        },
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

  Widget _buildTabContent(UserProfile user) {
    switch (_selectedTab) {
      case 'achievements':
        return _buildAchievementsTab(user);
      case 'rewards':
        return _buildRewardsTab(user);
      case 'leaderboard':
        return _buildLeaderboardTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAchievementsTab(UserProfile user) {
    final achievements = DummyData.achievements;
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Progress Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$unlockedCount/${achievements.length}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: achievements.isNotEmpty ? unlockedCount / achievements.length : 0,
                  backgroundColor: AppTheme.lightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((achievements.isNotEmpty ? unlockedCount / achievements.length : 0) * 100).toInt()}% Complete',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Achievements List
        ...achievements.map((achievement) => _buildAchievementCard(achievement)),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: achievement.isUnlocked 
                    ? AppTheme.primaryPurple.withOpacity(0.2)
                    : AppTheme.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  achievement.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: achievement.isUnlocked ? AppTheme.darkGrey : AppTheme.darkGrey.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: achievement.isUnlocked 
                          ? AppTheme.darkGrey.withOpacity(0.7)
                          : AppTheme.darkGrey.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.stars,
                        size: 16,
                        color: achievement.isUnlocked ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${achievement.pointsRewarded} points',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: achievement.isUnlocked ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (achievement.isUnlocked && achievement.unlockedDate != null) ...[
                        const Spacer(),
                        Text(
                          'Unlocked ${_formatDate(achievement.unlockedDate!)}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.successGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (achievement.isUnlocked)
              Icon(
                Icons.check_circle,
                color: AppTheme.successGreen,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsTab(UserProfile user) {
    final rewards = DummyData.rewardItems;
    final affordableRewards = rewards.where((r) => user.points >= r.pointsRequired).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Available Points Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.primaryPurple,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Points',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${user.points} points',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Affordable Rewards Section
        if (affordableRewards.isNotEmpty) ...[
          Text(
            'Rewards You Can Afford',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.darkGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...affordableRewards.map((reward) => _buildRewardCard(reward, user, true)),
          const SizedBox(height: 24),
        ],

        // All Rewards Section
        Text(
          'All Available Rewards',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.darkGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...rewards.map((reward) => _buildRewardCard(reward, user, false)),
      ],
    );
  }

  Widget _buildRewardCard(RewardItem reward, UserProfile user, bool isAffordable) {
    final canAfford = user.points >= reward.pointsRequired;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: canAfford 
                    ? AppTheme.primaryPurple.withOpacity(0.2)
                    : AppTheme.lightGrey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.card_giftcard,
                  color: canAfford ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.4),
                  size: 24,
                ),
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
                      color: canAfford ? AppTheme.darkGrey : AppTheme.darkGrey.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: canAfford 
                          ? AppTheme.darkGrey.withOpacity(0.7)
                          : AppTheme.darkGrey.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.stars,
                        size: 16,
                        color: canAfford ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reward.pointsRequired} points',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: canAfford ? AppTheme.primaryPurple : AppTheme.darkGrey.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(reward.category).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          reward.category.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _getCategoryColor(reward.category),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (canAfford)
              ElevatedButton(
                onPressed: () => _redeemReward(reward),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: AppTheme.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Redeem'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab() {
    final users = DummyData.users;
    final sortedUsers = List<UserProfile>.from(users)
      ..sort((a, b) => b.points.compareTo(a.points));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Top Health Champions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ...sortedUsers.take(10).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final user = entry.value;
                  return _buildLeaderboardItem(index + 1, user);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(int rank, UserProfile user) {
    Color rankColor;
    IconData rankIcon;

    switch (rank) {
      case 1:
        rankColor = Colors.amber;
        rankIcon = Icons.emoji_events;
        break;
      case 2:
        rankColor = Colors.grey;
        rankIcon = Icons.emoji_events;
        break;
      case 3:
        rankColor = Colors.brown;
        rankIcon = Icons.emoji_events;
        break;
      default:
        rankColor = AppTheme.darkGrey.withOpacity(0.5);
        rankIcon = Icons.circle;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                rankIcon,
                color: rankColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user.role.replaceAll('_', ' ').toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${user.points} pts',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _redeemReward(RewardItem reward) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Redeem ${reward.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to redeem this reward?'),
            const SizedBox(height: 8),
            Text(
              'Cost: ${reward.pointsRequired} points',
              style: TextStyle(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (reward.redemptionCode.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Redemption Code: ${reward.redemptionCode}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
                             context.read<AppState>().redeemReward(reward);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${reward.name} redeemed successfully!'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: AppTheme.white,
            ),
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'health':
        return AppTheme.successGreen;
      case 'transport':
        return AppTheme.secondaryBlue;
      case 'market':
        return AppTheme.accentPink;
      case 'entertainment':
        return AppTheme.primaryPurple;
      default:
        return AppTheme.darkGrey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
