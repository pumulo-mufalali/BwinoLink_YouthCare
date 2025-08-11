import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../data/dummy_data.dart';

class AddScreeningScreen extends StatefulWidget {
  const AddScreeningScreen({super.key});

  @override
  State<AddScreeningScreen> createState() => _AddScreeningScreenState();
}

class _AddScreeningScreenState extends State<AddScreeningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _patientPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedTestType = 'Blood Pressure';
  String _selectedResult = '';
  String _selectedStatus = 'normal';

  final List<String> _testTypes = [
    'Blood Pressure',
    'Blood Sugar',
    'BMI',
    'Cholesterol',
    'Vision Test',
    'Hearing Test',
    'HIV',
  ];

  final Map<String, List<String>> _testResults = {
    'Blood Pressure': ['120/80 mmHg', '140/90 mmHg', '160/100 mmHg', 'Other'],
    'Blood Sugar': ['80 mg/dL', '120 mg/dL', '180 mg/dL', '250 mg/dL', 'Other'],
    'BMI': ['18.5', '22.0', '25.0', '30.0', 'Other'],
    'Cholesterol': ['150 mg/dL', '200 mg/dL', '240 mg/dL', 'Other'],
    'Vision Test': ['20/20', '20/40', '20/60', '20/80', 'Other'],
    'Hearing Test': [
      'Normal',
      'Mild Loss',
      'Moderate Loss',
      'Severe Loss',
      'Other'
    ],
    'HIV': ['Negative', 'Positive', 'Indeterminate', 'Other'],
  };

  @override
  void initState() {
    super.initState();
    _updateResultsForTestType();
  }

  void _updateResultsForTestType() {
    setState(() {
      _selectedResult = _testResults[_selectedTestType]?.first ?? '';
    });
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitScreening() {
    if (_formKey.currentState!.validate()) {
      final screening = ScreeningResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientName: _patientNameController.text.trim(),
        patientPhone: _patientPhoneController.text.trim(),
        testType: _selectedTestType,
        result: _selectedResult,
        date: DateTime.now(),
        status: _selectedStatus,
        notes: _notesController.text.trim(),
      );

      // Add to app state
      context.read<AppState>().addScreening(screening);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Screening recorded successfully for ${screening.patientName}'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user has permission to access this screen
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add New Screening'),
            backgroundColor: AppTheme.secondaryBlue,
            foregroundColor: AppTheme.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.medical_services,
                                color: AppTheme.secondaryBlue,
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Record Health Screening',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: AppTheme.secondaryBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      'Add a new health screening result for a market visitor',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.darkGrey
                                                .withOpacity(0.7),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Patient Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patient Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _patientNameController,
                            decoration: const InputDecoration(
                              labelText: 'Patient Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter patient name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _patientPhoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter phone number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Test Information
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Test Information',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedTestType,
                            decoration: const InputDecoration(
                              labelText: 'Test Type',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.science),
                            ),
                            items: _testTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTestType = value!;
                                _updateResultsForTestType();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedResult,
                            decoration: const InputDecoration(
                              labelText: 'Test Result',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.analytics),
                            ),
                            items:
                                _testResults[_selectedTestType]?.map((result) {
                                      return DropdownMenuItem(
                                        value: result,
                                        child: Text(result),
                                      );
                                    }).toList() ??
                                    [],
                            onChanged: (value) {
                              setState(() {
                                _selectedResult = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a test result';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.info),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'normal',
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: AppTheme.primaryGreen),
                                    const SizedBox(width: 8),
                                    const Text('Normal'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'abnormal',
                                child: Row(
                                  children: [
                                    Icon(Icons.warning,
                                        color: AppTheme.warningOrange),
                                    const SizedBox(width: 8),
                                    const Text('Abnormal'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'pending',
                                child: Row(
                                  children: [
                                    Icon(Icons.schedule,
                                        color: AppTheme.secondaryBlue),
                                    const SizedBox(width: 8),
                                    const Text('Pending'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Additional Notes
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Notes',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppTheme.darkGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                              labelText: 'Notes (Optional)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.note),
                              hintText:
                                  'Add any additional observations or recommendations...',
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitScreening,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Record Screening',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
