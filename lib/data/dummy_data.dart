// Enhanced data models for BwinoLink YouthCare
// Supporting youth-focused health services, gamification, and community access points

class UserProfile {
  final String name;
  final String phoneNumber;
  final String role; // 'youth', 'staff', 'peer_navigator', 'vendor'
  final int points;
  final String profileImage;
  final int age;
  final String location;
  final List<String> interests;
  final bool isActive;

  UserProfile({
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.points,
    this.profileImage = '',
    this.age = 0,
    this.location = '',
    this.interests = const [],
    this.isActive = true,
  });
}

// Enhanced health screening result with youth-focused services
class ScreeningResult {
  final String id;
  final String patientName;
  final String patientPhone;
  final String testType;
  final String result;
  final DateTime date;
  final String status; // 'normal', 'abnormal', 'pending', 'follow_up_needed'
  final String notes;
  final String location; // 'market', 'school', 'youth_center', 'clinic'
  final String conductedBy;
  final bool requiresFollowUp;
  final String followUpInstructions;

  ScreeningResult({
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.testType,
    required this.result,
    required this.date,
    required this.status,
    this.notes = '',
    this.location = 'clinic',
    this.conductedBy = '',
    this.requiresFollowUp = false,
    this.followUpInstructions = '',
  });
}

// Enhanced reward system with gamification
class RewardItem {
  final String id;
  final String name;
  final String description;
  final int pointsRequired;
  final String imageUrl;
  final bool isAvailable;
  final String category; // 'health', 'transport', 'market', 'entertainment'
  final String redemptionCode;
  final Duration expiryDuration;

  RewardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRequired,
    this.imageUrl = '',
    this.isAvailable = true,
    this.category = 'health',
    this.redemptionCode = '',
    this.expiryDuration = const Duration(days: 30),
  });
}

// New model for health access points
class HealthAccessPoint {
  final String id;
  final String name;
  final String type; // 'market', 'school', 'youth_center', 'clinic'
  final String location;
  final List<String> services;
  final String contactPerson;
  final String phoneNumber;
  final bool isActive;
  final Map<String, dynamic> schedule;

  HealthAccessPoint({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.services,
    required this.contactPerson,
    required this.phoneNumber,
    this.isActive = true,
    this.schedule = const {},
  });
}

// New model for peer navigator assignments
class PeerNavigatorAssignment {
  final String id;
  final String youthId;
  final String peerNavigatorId;
  final DateTime assignedDate;
  final String status; // 'active', 'completed', 'discontinued'
  final List<String> supportAreas;
  final String notes;

  PeerNavigatorAssignment({
    required this.id,
    required this.youthId,
    required this.peerNavigatorId,
    required this.assignedDate,
    this.status = 'active',
    this.supportAreas = const [],
    this.notes = '',
  });
}

// New model for gamification achievements
class Achievement {
  final String id;
  final String name;
  final String description;
  final int pointsRewarded;
  final String icon;
  final bool isUnlocked;
  final DateTime? unlockedDate;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsRewarded,
    this.icon = '',
    this.isUnlocked = false,
    this.unlockedDate,
  });
}

// Enhanced dummy data instances
class DummyData {
  // Sample user profiles with youth focus
  static final List<UserProfile> users = [
    UserProfile(
      name: 'Waku Nabiwa',
      phoneNumber: '0967839012',
      role: 'youth',
      points: 150,
      age: 19,
      location: 'Lusaka Market Area',
      interests: ['fitness', 'music', 'health'],
    ),
    UserProfile(
      name: 'Dr. Simataa Mutafela',
      phoneNumber: '0767839012',
      role: 'staff',
      points: 450,
      age: 35,
      location: 'Central Clinic',
    ),
    UserProfile(
      name: 'Sarah Mwamba',
      phoneNumber: '0971234567',
      role: 'peer_navigator',
      points: 320,
      age: 22,
      location: 'Youth Center',
      interests: ['counseling', 'community_health'],
    ),
    UserProfile(
      name: 'John Banda',
      phoneNumber: '0967890123',
      role: 'vendor',
      points: 80,
      age: 28,
      location: 'Market Stall 15',
    ),
    UserProfile(
      name: 'Demo Youth',
      phoneNumber: '1234567890',
      role: 'youth',
      points: 100,
      age: 18,
      location: 'Demo Area',
      interests: ['sports', 'technology'],
    ),
  ];

  // Enhanced screening results with youth-focused services
  static final List<ScreeningResult> screeningResults = [
    ScreeningResult(
      id: '1',
      patientName: 'Alice Kakula',
      patientPhone: '0971217311',
      testType: 'Blood Pressure',
      result: '120/80 mmHg',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'normal',
      notes: 'Patient shows normal blood pressure readings.',
      location: 'market',
      conductedBy: 'Dr. Simataa',
    ),
    ScreeningResult(
      id: '2',
      patientName: 'Robert Chungu',
      patientPhone: '0971217311',
      testType: 'HIV Self-Test',
      result: 'Negative',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'normal',
      notes: 'HIV self-test completed successfully.',
      location: 'youth_center',
      conductedBy: 'Sarah Mwamba',
    ),
    ScreeningResult(
      id: '3',
      patientName: 'Carol Mwangala',
      patientPhone: '0971217311',
      testType: 'Contraceptive Counseling',
      result: 'Completed',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'normal',
      notes: 'Patient received comprehensive contraceptive information.',
      location: 'clinic',
      conductedBy: 'Dr. Simataa',
    ),
    ScreeningResult(
      id: '4',
      patientName: 'David Lubasi',
      patientPhone: '0971217311',
      testType: 'Blood Sugar',
      result: '180 mg/dL',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'abnormal',
      notes: 'Elevated blood sugar levels detected.',
      location: 'market',
      conductedBy: 'Dr. Simataa',
      requiresFollowUp: true,
      followUpInstructions: 'Schedule clinic visit within 1 week',
    ),
    ScreeningResult(
      id: '5',
      patientName: 'Eve Namukolo',
      patientPhone: '0971217311',
      testType: 'Mental Health Screening',
      result: 'Mild Anxiety',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'follow_up_needed',
      notes: 'Patient shows signs of mild anxiety.',
      location: 'school',
      conductedBy: 'Sarah Mwamba',
      requiresFollowUp: true,
      followUpInstructions: 'Peer navigator assigned for support',
    ),
    ScreeningResult(
      id: '6',
      patientName: 'Demo Youth',
      patientPhone: '1234567890',
      testType: 'BMI',
      result: '22.5',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'normal',
      notes: 'Healthy BMI range.',
      location: 'youth_center',
      conductedBy: 'Sarah Mwamba',
    ),
  ];

  // Enhanced reward items with gamification
  static final List<RewardItem> rewardItems = [
    RewardItem(
      id: '1',
      name: 'Free Health Checkup',
      description: 'Complimentary comprehensive health screening',
      pointsRequired: 100,
      category: 'health',
      redemptionCode: 'HEALTH100',
    ),
    RewardItem(
      id: '2',
      name: 'Transport Voucher',
      description: 'K50 transport voucher for clinic visits',
      pointsRequired: 150,
      category: 'transport',
      redemptionCode: 'TRANS150',
    ),
    RewardItem(
      id: '3',
      name: 'Market Food Voucher',
      description: 'K30 voucher for healthy food at partner markets',
      pointsRequired: 200,
      category: 'market',
      redemptionCode: 'FOOD200',
    ),
    RewardItem(
      id: '4',
      name: 'Movie Ticket',
      description: 'Free movie ticket for stress relief',
      pointsRequired: 300,
      category: 'entertainment',
      redemptionCode: 'MOVIE300',
    ),
    RewardItem(
      id: '5',
      name: 'Fitness Tracker',
      description: 'Smart watch to monitor daily activity',
      pointsRequired: 500,
      category: 'health',
      redemptionCode: 'FIT500',
    ),
  ];

  // Health access points
  static final List<HealthAccessPoint> healthAccessPoints = [
    HealthAccessPoint(
      id: '1',
      name: 'Lusaka Central Market',
      type: 'market',
      location: 'Lusaka CBD',
      services: ['Blood Pressure', 'Blood Sugar', 'HIV Self-Test', 'BMI'],
      contactPerson: 'John Banda',
      phoneNumber: '0967890123',
      schedule: {
        'monday': '08:00-16:00',
        'tuesday': '08:00-16:00',
        'wednesday': '08:00-16:00',
        'thursday': '08:00-16:00',
        'friday': '08:00-16:00',
      },
    ),
    HealthAccessPoint(
      id: '2',
      name: 'Youth Empowerment Center',
      type: 'youth_center',
      location: 'Kalingalinga',
      services: ['Mental Health Screening', 'Contraceptive Counseling', 'HIV Self-Test'],
      contactPerson: 'Sarah Mwamba',
      phoneNumber: '0971234567',
      schedule: {
        'monday': '10:00-18:00',
        'tuesday': '10:00-18:00',
        'wednesday': '10:00-18:00',
        'thursday': '10:00-18:00',
        'friday': '10:00-18:00',
        'saturday': '10:00-16:00',
      },
    ),
    HealthAccessPoint(
      id: '3',
      name: 'Central Clinic',
      type: 'clinic',
      location: 'Lusaka Central',
      services: ['All Services', 'Follow-up Care', 'Specialist Referrals'],
      contactPerson: 'Dr. Simataa Mutafela',
      phoneNumber: '0767839012',
      schedule: {
        'monday': '08:00-17:00',
        'tuesday': '08:00-17:00',
        'wednesday': '08:00-17:00',
        'thursday': '08:00-17:00',
        'friday': '08:00-17:00',
      },
    ),
  ];

  // Peer navigator assignments
  static final List<PeerNavigatorAssignment> peerNavigatorAssignments = [
    PeerNavigatorAssignment(
      id: '1',
      youthId: '0967839012',
      peerNavigatorId: '0971234567',
      assignedDate: DateTime.now().subtract(const Duration(days: 5)),
      supportAreas: ['mental_health', 'sexual_health'],
      notes: 'Regular check-ins scheduled',
    ),
  ];

  // Achievements for gamification
  static final List<Achievement> achievements = [
    Achievement(
      id: '1',
      name: 'First Screening',
      description: 'Complete your first health screening',
      pointsRewarded: 50,
      icon: '🎯',
    ),
    Achievement(
      id: '2',
      name: 'Health Champion',
      description: 'Complete 5 screenings in a month',
      pointsRewarded: 100,
      icon: '🏆',
    ),
    Achievement(
      id: '3',
      name: 'Peer Supporter',
      description: 'Help 3 friends join the platform',
      pointsRewarded: 150,
      icon: '🤝',
    ),
    Achievement(
      id: '4',
      name: 'Market Explorer',
      description: 'Visit 3 different health access points',
      pointsRewarded: 75,
      icon: '🏪',
    ),
  ];

  // Enhanced test types for youth-focused services
  static final List<String> availableTestTypes = [
    'Blood Pressure',
    'Blood Sugar',
    'BMI',
    'HIV Self-Test',
    'Contraceptive Counseling',
    'Mental Health Screening',
    'Pregnancy Test',
    'STI Information',
    'Nutrition Assessment',
    'Physical Activity Check',
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
        .where((screening) => screening.status == 'abnormal' || screening.status == 'follow_up_needed')
        .toList();
  }

  // Get available rewards for user points
  static List<RewardItem> getAvailableRewards(int userPoints) {
    return rewardItems
        .where((reward) =>
            reward.isAvailable && reward.pointsRequired <= userPoints)
        .toList();
  }

  // Get health access points by type
  static List<HealthAccessPoint> getAccessPointsByType(String type) {
    return healthAccessPoints
        .where((point) => point.type == type && point.isActive)
        .toList();
  }

  // Get peer navigator assignment for youth
  static PeerNavigatorAssignment? getPeerNavigatorAssignment(String youthId) {
    try {
      return peerNavigatorAssignments
          .firstWhere((assignment) => assignment.youthId == youthId && assignment.status == 'active');
    } catch (e) {
      return null;
    }
  }

  // Get achievements for user
  static List<Achievement> getUserAchievements() {
    return achievements;
  }
}
