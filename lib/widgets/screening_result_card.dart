import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';

class ScreeningResultCard extends StatelessWidget {
  final ScreeningResult screening;
  final VoidCallback onTap;

  const ScreeningResultCard({
    super.key,
    required this.screening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAbnormal = screening.status == 'abnormal';
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status indicator
              Row(
                children: [
                  // Status icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isAbnormal 
                          ? AppTheme.warningOrange.withOpacity(0.2)
                          : AppTheme.successGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isAbnormal ? Icons.warning : Icons.check_circle,
                      color: isAbnormal ? AppTheme.warningOrange : AppTheme.successGreen,
                      size: 20,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Test type and status
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          screening.testType,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.darkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          screening.status.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: isAbnormal ? AppTheme.warningOrange : AppTheme.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Date
                  Text(
                    _formatDate(screening.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.darkGrey.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Result value
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isAbnormal 
                      ? AppTheme.warningOrange.withOpacity(0.1)
                      : AppTheme.lightPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAbnormal 
                        ? AppTheme.warningOrange.withOpacity(0.3)
                        : AppTheme.lightPurple.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.science,
                      color: isAbnormal ? AppTheme.warningOrange : AppTheme.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        screening.result,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isAbnormal ? AppTheme.warningOrange : AppTheme.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Patient info (for staff)
              if (screening.patientName != screening.patientPhone) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: AppTheme.darkGrey.withOpacity(0.6),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        screening.patientName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.8),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Notes preview (if available)
              if (screening.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.note,
                      color: AppTheme.darkGrey.withOpacity(0.6),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        screening.notes,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.darkGrey.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Tap indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Tap to view details',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primaryPurple,
                    size: 12,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Format date for display
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
