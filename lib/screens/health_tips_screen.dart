import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'all',
    'sexual_health',
    'mental_health',
    'nutrition',
    'exercise',
    'substance_abuse',
    'general_health',
  ];

  final Map<String, String> _categoryNames = {
    'all': 'All Tips',
    'sexual_health': 'Sexual Health',
    'mental_health': 'Mental Health',
    'nutrition': 'Nutrition',
    'exercise': 'Exercise',
    'substance_abuse': 'Substance Abuse',
    'general_health': 'General Health',
  };

  final List<Map<String, dynamic>> _healthTips = [
    {
      'id': '1',
      'title': 'Safe Sex Practices',
      'category': 'sexual_health',
      'content': 'Always use protection during sexual activity. Condoms are the most effective way to prevent STIs and unwanted pregnancies. Get tested regularly and know your status.',
      'image': 'assets/images/safe_sex.png',
      'tags': ['STI Prevention', 'Contraception', 'Testing'],
      'isBookmarked': false,
      'readTime': '3 min read',
    },
    {
      'id': '2',
      'title': 'Managing Stress and Anxiety',
      'category': 'mental_health',
      'content': 'Practice deep breathing exercises, meditation, or yoga to manage stress. Talk to someone you trust about your feelings. Consider seeking professional help if needed.',
      'image': 'assets/images/mental_health.png',
      'tags': ['Stress Management', 'Anxiety', 'Wellness'],
      'isBookmarked': false,
      'readTime': '5 min read',
    },
    {
      'id': '3',
      'title': 'Healthy Eating on a Budget',
      'category': 'nutrition',
      'content': 'Choose local, seasonal fruits and vegetables. Include protein sources like beans, eggs, and fish. Drink plenty of water and limit sugary drinks.',
      'image': 'assets/images/nutrition.png',
      'tags': ['Budget', 'Healthy Eating', 'Local Food'],
      'isBookmarked': false,
      'readTime': '4 min read',
    },
    {
      'id': '4',
      'title': 'Simple Home Workouts',
      'category': 'exercise',
      'content': 'You don\'t need a gym to stay fit. Try push-ups, squats, jumping jacks, or dancing. Aim for 30 minutes of physical activity daily.',
      'image': 'assets/images/exercise.png',
      'tags': ['Home Workout', 'Fitness', 'No Equipment'],
      'isBookmarked': false,
      'readTime': '6 min read',
    },
    {
      'id': '5',
      'title': 'Understanding Alcohol and Drugs',
      'category': 'substance_abuse',
      'content': 'Know the risks of substance use. If you choose to drink, do so responsibly. Never drive under the influence. Seek help if you\'re struggling with addiction.',
      'image': 'assets/images/substance_abuse.png',
      'tags': ['Alcohol', 'Drugs', 'Responsibility'],
      'isBookmarked': false,
      'readTime': '7 min read',
    },
    {
      'id': '6',
      'title': 'Getting Enough Sleep',
      'category': 'general_health',
      'content': 'Aim for 7-9 hours of sleep per night. Create a bedtime routine, avoid screens before bed, and keep your bedroom cool and dark.',
      'image': 'assets/images/sleep.png',
      'tags': ['Sleep', 'Wellness', 'Routine'],
      'isBookmarked': false,
      'readTime': '3 min read',
    },
    {
      'id': '7',
      'title': 'HIV Testing and Prevention',
      'category': 'sexual_health',
      'content': 'Get tested for HIV regularly, especially if you\'re sexually active. Use condoms consistently and correctly. Consider PrEP if you\'re at high risk.',
      'image': 'assets/images/hiv_testing.png',
      'tags': ['HIV', 'Testing', 'Prevention'],
      'isBookmarked': false,
      'readTime': '4 min read',
    },
    {
      'id': '8',
      'title': 'Building Self-Confidence',
      'category': 'mental_health',
      'content': 'Focus on your strengths and achievements. Practice positive self-talk. Set realistic goals and celebrate small wins. Surround yourself with supportive people.',
      'image': 'assets/images/confidence.png',
      'tags': ['Self-Confidence', 'Positive Thinking', 'Goals'],
      'isBookmarked': false,
      'readTime': '5 min read',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTips = _getFilteredTips();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tips'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _showBookmarkedTips(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search health tips...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(_categoryNames[category]!),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: AppTheme.lightPurple,
                          checkmarkColor: AppTheme.primaryPurple,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryPurple : Colors.grey[600],
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Tips List
          Expanded(
            child: filteredTips.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredTips.length,
                    itemBuilder: (context, index) {
                      return _buildTipCard(filteredTips[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredTips() {
    List<Map<String, dynamic>> filtered = _healthTips;

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered.where((tip) => tip['category'] == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((tip) {
        return tip['title'].toLowerCase().contains(query) ||
               tip['content'].toLowerCase().contains(query) ||
               (tip['tags'] as List<String>).any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tips found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => _showTipDetail(tip),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tip['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      tip['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
                      color: tip['isBookmarked'] ? AppTheme.primaryPurple : Colors.grey,
                    ),
                    onPressed: () => _toggleBookmark(tip),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tip['content'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              // Tags
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: (tip['tags'] as List<String>).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tip['readTime'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _categoryNames[tip['category']]!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTipDetail(Map<String, dynamic> tip) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tip['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      tip['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
                      color: tip['isBookmarked'] ? AppTheme.primaryPurple : Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _toggleBookmark(tip);
                    },
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and read time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.lightPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _categoryNames[tip['category']]!,
                            style: TextStyle(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tip['readTime'],
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Main content
                    Text(
                      tip['content'],
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tags
                    Text(
                      'Tags:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: (tip['tags'] as List<String>).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.lightPurple.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: AppTheme.primaryPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _shareTip(tip),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryPurple,
                              side: BorderSide(color: AppTheme.primaryPurple),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _getRelatedServices(tip),
                            icon: const Icon(Icons.medical_services),
                            label: const Text('Get Help'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBookmark(Map<String, dynamic> tip) {
    setState(() {
      tip['isBookmarked'] = !tip['isBookmarked'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          tip['isBookmarked'] ? 'Tip bookmarked!' : 'Tip removed from bookmarks',
        ),
        backgroundColor: AppTheme.primaryPurple,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showBookmarkedTips() {
    final bookmarkedTips = _healthTips.where((tip) => tip['isBookmarked']).toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Bookmarked Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: bookmarkedTips.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookmarked tips',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bookmark tips you want to save for later',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: bookmarkedTips.length,
                      itemBuilder: (context, index) {
                        return _buildTipCard(bookmarkedTips[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareTip(Map<String, dynamic> tip) {
    // In a real app, this would integrate with the device's share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${tip['title']}'),
        backgroundColor: AppTheme.primaryPurple,
      ),
    );
  }

  void _getRelatedServices(Map<String, dynamic> tip) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Get Help'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Related services for: ${tip['title']}'),
              const SizedBox(height: 16),
              const Text('• Book an appointment'),
              const Text('• Chat with peer navigator'),
              const Text('• Find nearby health services'),
              const Text('• Call helpline'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to booking screen
                Navigator.pushNamed(context, '/booking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Book Appointment'),
            ),
          ],
        );
      },
    );
  }
}
