import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class HealthAccessPointsScreen extends StatefulWidget {
  const HealthAccessPointsScreen({super.key});

  @override
  State<HealthAccessPointsScreen> createState() => _HealthAccessPointsScreenState();
}

class _HealthAccessPointsScreenState extends State<HealthAccessPointsScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Access Points'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: AppTheme.white,
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final accessPoints = appState.getAccessPointsByType(_selectedFilter);
          
          return Column(
            children: [
              // Filter Section
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.lightPurple.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Health Services Near You',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'All', Icons.location_on),
                          const SizedBox(width: 8),
                          _buildFilterChip('market', 'Markets', Icons.store),
                          const SizedBox(width: 8),
                          _buildFilterChip('school', 'Schools', Icons.school),
                          const SizedBox(width: 8),
                          _buildFilterChip('youth_center', 'Youth Centers', Icons.people),
                          const SizedBox(width: 8),
                          _buildFilterChip('clinic', 'Clinics', Icons.local_hospital),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Access Points List
              Expanded(
                child: accessPoints.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 64,
                              color: AppTheme.darkGrey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No access points found',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.darkGrey.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try changing the filter or check back later',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.darkGrey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: accessPoints.length,
                        itemBuilder: (context, index) {
                          final accessPoint = accessPoints[index];
                          return _buildAccessPointCard(context, accessPoint);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? AppTheme.white : AppTheme.primaryPurple,
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: AppTheme.white,
      selectedColor: AppTheme.primaryPurple,
      checkmarkColor: AppTheme.white,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.white : AppTheme.primaryPurple,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAccessPointCard(BuildContext context, HealthAccessPoint accessPoint) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showAccessPointDetails(context, accessPoint),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getAccessPointColor(accessPoint.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getAccessPointIcon(accessPoint.type),
                      color: _getAccessPointColor(accessPoint.type),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accessPoint.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.darkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          accessPoint.location,
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
                      color: accessPoint.isActive 
                          ? AppTheme.successGreen.withOpacity(0.2)
                          : AppTheme.errorRed.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      accessPoint.isActive ? 'Open' : 'Closed',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: accessPoint.isActive ? AppTheme.successGreen : AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Services
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: accessPoint.services.take(3).map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.lightPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              if (accessPoint.services.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${accessPoint.services.length - 3} more services',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.darkGrey.withOpacity(0.6),
                    ),
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // Contact Info
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: AppTheme.darkGrey.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    accessPoint.phoneNumber,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGrey.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppTheme.darkGrey.withOpacity(0.4),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccessPointDetails(BuildContext context, HealthAccessPoint accessPoint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.darkGrey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getAccessPointColor(accessPoint.type).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getAccessPointIcon(accessPoint.type),
                              color: _getAccessPointColor(accessPoint.type),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  accessPoint.name,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.darkGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  accessPoint.location,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.darkGrey.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: accessPoint.isActive 
                              ? AppTheme.successGreen.withOpacity(0.1)
                              : AppTheme.errorRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accessPoint.isActive 
                                ? AppTheme.successGreen.withOpacity(0.3)
                                : AppTheme.errorRed.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              accessPoint.isActive ? Icons.check_circle : Icons.cancel,
                              color: accessPoint.isActive ? AppTheme.successGreen : AppTheme.errorRed,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    accessPoint.isActive ? 'Currently Open' : 'Currently Closed',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: accessPoint.isActive ? AppTheme.successGreen : AppTheme.errorRed,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (accessPoint.schedule.isNotEmpty)
                                    Text(
                                      'Mon-Fri: 08:00-16:00',
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
                      
                      const SizedBox(height: 24),
                      
                      // Services
                      Text(
                        'Available Services',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: accessPoint.services.map((service) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.lightPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppTheme.lightPurple.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              service,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Contact Information
                      Text(
                        'Contact Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                                             _buildContactItem(
                         Icons.person,
                         'Contact Person',
                         accessPoint.contactPerson,
                       ),
                      const SizedBox(height: 8),
                      _buildContactItem(
                        Icons.phone,
                        'Phone Number',
                        accessPoint.phoneNumber,
                        isPhone: true,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Implement directions
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Directions feature coming soon!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Get Directions'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryPurple,
                                side: BorderSide(color: AppTheme.primaryPurple),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement booking
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Booking feature coming soon!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.calendar_today),
                              label: const Text('Book Appointment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: AppTheme.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, {bool isPhone = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.darkGrey.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.darkGrey.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isPhone)
            IconButton(
              onPressed: () {
                // TODO: Implement call functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Call feature coming soon!'),
                  ),
                );
              },
              icon: Icon(
                Icons.call,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Color _getAccessPointColor(String type) {
    switch (type) {
      case 'market':
        return AppTheme.accentPink;
      case 'school':
        return AppTheme.secondaryBlue;
      case 'youth_center':
        return AppTheme.primaryPurple;
      case 'clinic':
        return AppTheme.successGreen;
      default:
        return AppTheme.primaryPurple;
    }
  }

  IconData _getAccessPointIcon(String type) {
    switch (type) {
      case 'market':
        return Icons.store;
      case 'school':
        return Icons.school;
      case 'youth_center':
        return Icons.people;
      case 'clinic':
        return Icons.local_hospital;
      default:
        return Icons.location_on;
    }
  }
}
