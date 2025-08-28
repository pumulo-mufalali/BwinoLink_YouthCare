class UserProfile {
  final String name;
  final String phoneNumber;
  final String role; // 'youth', 'staff', 'peer_navigator', 'vendor'
  final int points;
  final int notifications;
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
    this.notifications = 0,
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
    this.isUnlocked = true,
    this.unlockedDate,
  });
}

// New model for health worker profiles
class HealthWorkerProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String specialization; // 'general', 'hiv_counselor', 'mental_health', 'sexual_health'
  final String location;
  final bool isOnline;
  final String availability; // 'available', 'busy', 'offline'

  HealthWorkerProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.specialization,
    required this.location,
    required this.isOnline,
    required this.availability,
  });
}

// New model for notifications
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'screening_result', 'reminder', 'achievement', 'message'
  final DateTime timestamp;
  final bool isRead;
  final String relatedId;
  final String action; // 'view_result', 'view_appointment', 'view_achievement', 'open_chat', 'view_tip'

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    required this.relatedId,
    required this.action,
  });
}

// New model for chat messages
class HealthWorkerMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  HealthWorkerMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
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
      points: 375,
      notifications: 2,
      age: 19,
      location: 'Lusaka Market Area',
      interests: ['fitness', 'music', 'health'],
    ),
    UserProfile(
      name: 'Dr. Simataa Mutafela',
      phoneNumber: '0767839012',
      role: 'staff',
      points: 450,
      notifications: 3,
      age: 35,
      location: 'Central Clinic',
    ),
    UserProfile(
      name: 'Sarah Mwamba',
      phoneNumber: '0971234567',
      role: 'peer_navigator',
      points: 100,
      notifications: 1,
      age: 22,
      location: 'Youth Center',
      interests: ['counseling', 'community_health'],
    ),
    UserProfile(
      name: 'Morgan Kakula',
      phoneNumber: '0974567890',
      role: 'youth',
      points: 50,
      notifications: 4,
      age: 18,
      location: 'Unza Clinic',
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
      result: 'Positive',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'follow_up_needed',
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
      status: 'follow_up_needed',
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
      patientName: 'Vincent Linyando',
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
      name: 'Downtown Mall, Town',
      type: 'market',
      location: 'Lusaka Central',
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
      name: 'Comesa, Town',
      type: 'youth_center',
      location: 'Lusaka Central',
      services: ['Contraceptive Counseling', 'Blood Sugar', 'HIV Self-Test'],
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
      name: 'UTH, Lusaka',
      type: 'hospital',
      location: 'Lusaka Central',
      services: ['All Services'],
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
    HealthAccessPoint(
      id: '3',
      name: 'Town, Mongu',
      type: 'market',
      location: 'Western Province',
      services: ['Blood Sugar', 'HIV Self-Test', 'Contraceptive Counseling', 'HIV Self-Test'],
      contactPerson: 'Dr. Wamundila Kakula',
      phoneNumber: '0967839078',
      schedule: {
        'monday': '08:00-13:00',
        'tuesday': '08:00-16:00',
        'wednesday': '08:00-15:00',
      },
    ),
    HealthAccessPoint(
      id: '4',
      name: 'Unza Clinic',
      type: 'school',
      location: 'The University of Zambia',
      services: ['Blood Pressure', 'HIV Self-Test', 'Contraceptive Counseling'],
      contactPerson: 'Dr. Simataa Mutafela',
      phoneNumber: '0767839078',
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

  // Health worker profiles
  static final List<HealthWorkerProfile> healthWorkers = [
    HealthWorkerProfile(
      id: '1',
      name: 'Dr. Simataa Mutafela',
      phoneNumber: '0767839012',
      specialization: 'general',
      location: 'Central Clinic',
      isOnline: true,
      availability: 'available',
    ),
    HealthWorkerProfile(
      id: '2',
      name: 'Dr. Vincent Kakula',
      phoneNumber: '0976543210',
      specialization: 'hiv_counselor',
      location: 'Youth Center',
      isOnline: true,
      availability: 'available',
    ),
    HealthWorkerProfile(
      id: '3',
      name: 'Dr. Katiba Ngongo',
      phoneNumber: '0961234567',
      specialization: 'mental_health',
      location: 'Mental Health Clinic',
      isOnline: false,
      availability: 'offline',
    ),
    HealthWorkerProfile(
      id: '4',
      name: 'Dr. Bupe Chilufya',
      phoneNumber: '0959876543',
      specialization: 'sexual_health',
      location: 'Family Planning Clinic',
      isOnline: true,
      availability: 'busy',
    ),
  ];

  // Sample notifications for youth
  static final List<NotificationItem> youthNotifications = [
    NotificationItem(
      id: '1',
      title: 'New Screening Result',
      message: 'Your blood pressure screening result is ready. Tap to view.',
      type: 'screening_result',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      relatedId: '1',
      action: 'view_result',
    ),
    NotificationItem(
      id: '2',
      title: 'Appointment Reminder',
      message: 'You have a follow-up appointment tomorrow at 2:00 PM.',
      type: 'reminder',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
      relatedId: 'appointment_1',
      action: 'view_appointment',
    ),
    NotificationItem(
      id: '3',
      title: 'Achievement Unlocked!',
      message: 'Congratulations! You\'ve earned the "First Screening" badge.',
      type: 'achievement',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      relatedId: '1',
      action: 'view_achievement',
    ),
    NotificationItem(
      id: '4',
      title: 'New Message',
      message: 'Dr. Simataa sent you a message about your recent screening.',
      type: 'message',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      relatedId: 'message_1',
      action: 'open_chat',
    ),
    NotificationItem(
      id: '5',
      title: 'Health Tip',
      message: 'Stay hydrated! Drink 8 glasses of water daily for better health.',
      type: 'reminder',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      relatedId: 'view_tip',
      action: 'view_tip',
    ),
  ];

  // Sample notifications for peer navigators
  static final List<NotificationItem> peerNavigatorNotifications = [
    NotificationItem(
      id: 'pn5',
      title: 'Monthly Report Due',
      message: 'Your monthly peer navigation report is due in 3 days.',
      type: 'reminder',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: false,
      relatedId: 'monthly_report',
      action: 'submit_report',
    ),
  ];

  // Sample notifications for doctors/health workers
  static final List<NotificationItem> doctorNotifications = [
    NotificationItem(
      id: 'dr2',
      title: 'Abnormal Results Alert',
      message: 'Blood sugar screening for Robert Chungu shows elevated levels.',
      type: 'abnormal_result',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
      relatedId: 'screening_robert_1',
      action: 'review_abnormal_result',
    ),
    NotificationItem(
      id: 'dr3',
      title: 'Follow-up Appointment',
      message: 'Follow-up appointment scheduled for Carol Mwangala tomorrow.',
      type: 'appointment',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
      relatedId: 'appointment_carol_1',
      action: 'view_appointment',
    ),
    NotificationItem(
      id: 'dr5',
      title: 'Weekly Summary',
      message: 'Weekly screening summary: 15 screenings, 3 abnormal results.',
      type: 'summary',
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
      relatedId: 'weekly_summary',
      action: 'view_summary',
    ),
    NotificationItem(
      id: 'dr6',
      title: 'Equipment Maintenance',
      message: 'Blood pressure monitor requires calibration. Schedule maintenance.',
      type: 'reminder',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: false,
      relatedId: 'equipment_maintenance',
      action: 'schedule_maintenance',
    ),
  ];

  // Sample chat messages between youth and health workers
  static final List<HealthWorkerMessage> healthWorkerMessages = [
    HealthWorkerMessage(
      id: '1',
      senderId: '0767839012', // Dr. Simataa
      receiverId: '0967839012', // Youth
      message: 'Hi! I\'ve reviewed your recent blood pressure screening. The results look good, but I\'d like to schedule a follow-up in 2 weeks to monitor your progress.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    HealthWorkerMessage(
      id: '2',
      senderId: '0967839012', // Youth
      receiverId: '0767839012', // Dr. Simataa
      message: 'Thank you, Dr. Simataa. That sounds good. What time would work best for you?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      isRead: true,
    ),
    HealthWorkerMessage(
      id: '3',
      senderId: '0767839012', // Dr. Simataa
      receiverId: '0967839012', // Youth
      message: 'I have availability on Tuesday and Thursday afternoons. Would Tuesday at 3:00 PM work for you?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
    ),
    HealthWorkerMessage(
      id: '4',
      senderId: '0967839012', // Youth
      receiverId: '0767839012', // Dr. Simataa
      message: 'Tuesday at 3:00 PM works perfectly. I\'ll see you then. Thank you!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
      isRead: true,
    ),
    HealthWorkerMessage(
      id: '5',
      senderId: '0767839012', // Dr. Simataa
      receiverId: '0967839012', // Youth
      message: 'Great! I\'ve scheduled you for Tuesday at 3:00 PM. Don\'t forget to bring your health record book. See you soon!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
      isRead: false,
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
