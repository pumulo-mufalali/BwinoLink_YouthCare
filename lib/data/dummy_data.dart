// User profile dummy data
class UserProfile {
  final String name;
  final String phoneNumber;
  final String role; // 'visitor' or 'champion'
  final int points;
  final String profileImage;

  UserProfile({
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.points,
    this.profileImage = '',
  });
}

// Health screening result dummy data
class ScreeningResult {
  final String id;
  final String patientName;
  final String patientPhone;
  final String testType;
  final String result;
  final DateTime date;
  final String status; // 'normal', 'abnormal', 'pending'
  final String notes;

  ScreeningResult({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.testType,
    required this.result,
    required this.date,
    required this.status,
    this.notes = '',
  });
}

// Reward item dummy data
class RewardItem {
  final String id;
  final String name;
  final String description;
  final int pointsRequired;
  final String imageUrl;
  final bool isAvailable;

  RewardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    this.imageUrl = '',
    this.isAvailable = true,
  });
}

// Dummy data instances
class DummyData {
  // Sample user profiles
  static final List<UserProfile> users = [
    UserProfile(
      name: 'Waku Nabiwa',
      phoneNumber: '+260967839012',
      role: 'visitor',
      points: 150,
    ),
    UserProfile(
      name: 'Dr. Simataa Mutafela',
      phoneNumber: '+260767839012',
      role: 'staff',
      points: 450,
    ),
  ];

  // Sample screening results
  static final List<ScreeningResult> screeningResults = [
    ScreeningResult(
      id: '1',
      patientName: 'Alice Kakula',
      patientPhone: '+260971217311',
      testType: 'Blood Pressure',
      result: '120/80 mmHg',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'normal',
      notes: 'Patient shows normal blood pressure readings.',
    ),
    ScreeningResult(
      id: '2',
      patientName: 'Robert Chungu',
      patientPhone: '+260971217311',
      testType: 'Blood Sugar',
      result: '180 mg/dL',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'abnormal',
      notes: 'Elevated blood sugar levels detected. Recommend follow-up.',
    ),
    ScreeningResult(
      id: '3',
      patientName: 'Carol Mwangala',
      patientPhone: '+260971217311',
      testType: 'BMI',
      result: '28.5',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'abnormal',
      notes: 'Patient is overweight. Suggest dietary consultation.',
    ),
    ScreeningResult(
      id: '4',
      patientName: 'David Lubasi',
      patientPhone: '+260971217311',
      testType: 'Blood Pressure',
      result: '110/70 mmHg',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'normal',
      notes: 'Excellent blood pressure readings.',
    ),
    ScreeningResult(
      id: '5',
      patientName: 'Eve Namukolo',
      patientPhone: '+260971217311',
      testType: 'Blood Sugar',
      result: '95 mg/dL',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'normal',
      notes: 'Normal fasting blood sugar levels.',
    ),
  ];

  // Sample reward items
  static final List<RewardItem> rewardItems = [
    RewardItem(
      id: '1',
      name: 'Free Health Checkup',
      description: 'Complimentary comprehensive health screening',
      pointsRequired: 100,
    ),
    RewardItem(
      id: '2',
      name: 'Health Supplements',
      description: 'Vitamin D and Omega-3 supplements pack',
      pointsRequired: 200,
    ),
    RewardItem(
      id: '3',
      name: 'Fitness Tracker',
      description: 'Smart watch to monitor daily activity',
      pointsRequired: 500,
    ),
    RewardItem(
      id: '4',
      name: 'Nutrition Consultation',
      description: '30-minute session with certified nutritionist',
      pointsRequired: 300,
    ),
    RewardItem(
      id: '5',
      name: 'Gym Membership',
      description: '1-month access to local fitness center',
      pointsRequired: 400,
    ),
  ];

  // Test types available for screenings
  static final List<String> availableTestTypes = [
    'Blood Pressure',
    'Blood Sugar',
    'BMI',
    'Cholesterol',
    'Vision Test',
    'Hearing Test',
    'Pulse Rate',
    'Temperature',
    'HIV',
  ];

  // Get current user (for demo purposes, using first user)
  static UserProfile get currentUser => users.first;

  // Get user by role
  static UserProfile? getUserByRole(String role) {
    try {
      return users.firstWhere((user) => user.role == role);
    } catch (e) {
      return null;
    }
  }

  // Get screenings by patient phone
  static List<ScreeningResult> getScreeningsByPhone(String phone) {
    return screeningResults
        .where((screening) => screening.patientPhone == phone)
        .toList();
  }

  // Get abnormal results
  static List<ScreeningResult> getAbnormalResults() {
    return screeningResults
        .where((screening) => screening.status == 'abnormal')
        .toList();
  }

  // Get available rewards for user points
  static List<RewardItem> getAvailableRewards(int userPoints) {
    return rewardItems
        .where((reward) => 
            reward.isAvailable && reward.pointsRequired <= userPoints)
        .toList();
  }
}
