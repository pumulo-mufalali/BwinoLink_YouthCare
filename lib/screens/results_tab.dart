import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';
import '../widgets/screening_result_card.dart';

class ResultsTab extends StatelessWidget {
  const ResultsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final screenings = appState.userScreenings;
        final user = appState.currentUser;

        if (user == null) return const SizedBox.shrink();

        return Column(
          children: [
            // Header with summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppTheme.white,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.darkGrey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Results',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.darkGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${screenings.length} Results',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Total',
                          '${screenings.length}',
                          Icons.medical_services,
                          AppTheme.primaryGreen,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Normal',
                          '${screenings.where((s) => s.status == 'normal').length}',
                          Icons.check_circle,
                          AppTheme.accentGreen,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          context,
                          'Abnormal',
                          '${screenings.where((s) => s.status == 'abnormal').length}',
                          Icons.warning,
                          AppTheme.warningOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Results list
            Expanded(
              child: screenings.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: screenings.length,
                      itemBuilder: (context, index) {
                        final screening = screenings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ScreeningResultCard(
                            screening: screening,
                            onTap: () => _showResultDetails(context, screening),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  // Build summary item
  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.darkGrey.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: AppTheme.darkGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.darkGrey.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your health screening results will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.darkGrey.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          // const SizedBox(height: 24),
          // ElevatedButton.icon(
          //   onPressed: () {
          //     // Navigate to add screening or home
          //     Navigator.pushNamed(context, '/add-screening');
          //   },
          //   icon: const Icon(Icons.add),
          //   label: const Text('Get Screened'),
          // ),
        ],
      ),
    );
  }

  // Show result details
  void _showResultDetails(BuildContext context, ScreeningResult screening) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ResultDetailsSheet(screening: screening),
    );
  }
}

// Result details bottom sheet
class _ResultDetailsSheet extends StatelessWidget {
  final ScreeningResult screening;

  const _ResultDetailsSheet({required this.screening});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: screening.status == 'abnormal' 
                              ? AppTheme.warningOrange.withOpacity(0.2)
                              : AppTheme.accentGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          screening.status == 'abnormal' 
                              ? Icons.warning 
                              : Icons.check_circle,
                          color: screening.status == 'abnormal' 
                              ? AppTheme.warningOrange 
                              : AppTheme.accentGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              screening.testType,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppTheme.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              screening.status.toUpperCase(),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: screening.status == 'abnormal' 
                                    ? AppTheme.warningOrange 
                                    : AppTheme.accentGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Patient info
                  _buildDetailSection(
                    context,
                    'Patient Information',
                    [
                      _buildDetailRow('Name', screening.patientName),
                      _buildDetailRow('Phone', screening.patientPhone),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Test details
                  _buildDetailSection(
                    context,
                    'Test Details',
                    [
                      _buildDetailRow('Test Type', screening.testType),
                      _buildDetailRow('Result', screening.result),
                      _buildDetailRow('Date', _formatDate(screening.date)),
                    ],
                  ),

                  if (screening.notes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildDetailSection(
                      context,
                      'Notes',
                      [
                        _buildDetailRow('', screening.notes, isNotes: true),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Recommendations
                  if (screening.status == 'abnormal') ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.warningOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.warningOrange.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppTheme.warningOrange,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Recommendation',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppTheme.warningOrange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please consult with a healthcare provider for further evaluation and treatment.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.darkGrey.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build detail section
  Widget _buildDetailSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.darkGrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  // Build detail row
  Widget _buildDetailRow(String label, String value, {bool isNotes = false}) {
    if (isNotes) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          value,
          style: const TextStyle(
            color: AppTheme.darkGrey,
            fontSize: 14,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.darkGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.darkGrey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
