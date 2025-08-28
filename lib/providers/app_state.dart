import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class AppState extends ChangeNotifier {
  // Current user
  UserProfile? _currentUser;
  UserProfile? get currentUser => _currentUser;

  // Authentication state
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Current screen index for bottom navigation
  int _currentScreenIndex = 0;
  int get currentScreenIndex => _currentScreenIndex;

  // Screening results for current user
  List<ScreeningResult> _userScreenings = [];
  List<ScreeningResult> get userScreenings => _userScreenings;

  // Available rewards for current user
  List<RewardItem> _availableRewards = [];
  List<RewardItem> get availableRewards => _availableRewards;

  // Health access points
  List<HealthAccessPoint> _healthAccessPoints = [];
  List<HealthAccessPoint> get healthAccessPoints => _healthAccessPoints;

  // Peer navigator assignment for current youth
  PeerNavigatorAssignment? _peerNavigatorAssignment;
  PeerNavigatorAssignment? get peerNavigatorAssignment => _peerNavigatorAssignment;

  // Achievements for current user
  List<Achievement> _userAchievements = [];
  List<Achievement> get userAchievements => _userAchievements;

  // Notifications for current user
  List<NotificationItem> _userNotifications = [];
  List<NotificationItem> get userNotifications => _userNotifications;

  // Constructor - initialize with default data
  AppState() {
    _initializeData();
  }

  // Initialize app data
  void _initializeData() {
    // Start with no user logged in - show login screen first
    _currentUser = null;
    _isLoggedIn = false;
    
    // Don't load data until user logs in
  }

  // Login with phone number (simplified for demo)
  void login(String phoneNumber) {
    // In a real app, this would validate against backend
    // For demo, we'll just set the user and mark as logged in
    _currentUser = DummyData.users.firstWhere(
      (user) => user.phoneNumber == phoneNumber,
      orElse: () => DummyData.currentUser,
    );
    _isLoggedIn = true;
    _loadUserData();
    notifyListeners();
  }

  // Create new user and login (for signup)
  void createUserAndLogin(UserProfile newUser) {
    // Add user to dummy data (in a real app, this would be sent to backend)
    DummyData.users.add(newUser);
    
    // Set as current user and login
    _currentUser = newUser;
    _isLoggedIn = true;
    _loadUserData();
    notifyListeners();
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _userScreenings.clear();
    _availableRewards.clear();
    _healthAccessPoints.clear();
    _peerNavigatorAssignment = null;
    _userAchievements.clear();
    notifyListeners();
  }

  // Change current screen
  void setCurrentScreen(int index) {
    _currentScreenIndex = index;
    notifyListeners();
  }

  // Load all user data based on current user
  void _loadUserData() {
    if (_currentUser != null) {
      _loadUserScreenings();
      _loadAvailableRewards();
      _loadHealthAccessPoints();
      _loadPeerNavigatorAssignment();
      _loadUserAchievements();
      _loadUserNotifications();
    }
  }

  // Load user screenings based on current user
  void _loadUserScreenings() {
    if (_currentUser != null) {
      if (_currentUser!.role == 'youth') {
        // For youth, show screenings with their phone number
        _userScreenings = DummyData.getScreeningsByPhone(_currentUser!.phoneNumber);
      } else if (_currentUser!.role == 'staff') {
        // For staff, show all screenings they've recorded
        _userScreenings = DummyData.screeningResults;
      } else if (_currentUser!.role == 'peer_navigator') {
        // For peer navigators, show screenings of assigned youth
        _userScreenings = DummyData.screeningResults.where((screening) {
          final assignment = DummyData.getPeerNavigatorAssignment(screening.patientPhone);
          return assignment?.peerNavigatorId == _currentUser!.phoneNumber;
        }).toList();
      } else {
        // For vendors, show screenings conducted at their location
        _userScreenings = DummyData.screeningResults.where((screening) {
          return screening.location == 'market';
        }).toList();
      }
    }
  }

  // Load available rewards for current user
  void _loadAvailableRewards() {
    if (_currentUser != null) {
      _availableRewards = DummyData.getAvailableRewards(_currentUser!.points);
    }
  }

  // Load health access points
  void _loadHealthAccessPoints() {
    _healthAccessPoints = DummyData.healthAccessPoints;
  }

  // Load peer navigator assignment for current youth
  void _loadPeerNavigatorAssignment() {
    if (_currentUser != null && _currentUser!.role == 'youth') {
      _peerNavigatorAssignment = DummyData.getPeerNavigatorAssignment(_currentUser!.phoneNumber);
    }
  }

  // Load user achievements
  void _loadUserAchievements() {
    _userAchievements = DummyData.getUserAchievements();
  }

  // Load user notifications
  void _loadUserNotifications() {
    if (_currentUser != null) {
      switch (_currentUser!.role) {
        case 'youth':
          _userNotifications = DummyData.youthNotifications;
          break;
        case 'peer_navigator':
          _userNotifications = DummyData.peerNavigatorNotifications;
          break;
        case 'staff':
          _userNotifications = DummyData.doctorNotifications;
          break;
        default:
          _userNotifications = [];
      }
    }
  }

  // Add new screening (for staff and peer navigators)
  void addScreening(ScreeningResult screening) {
    // In a real app, this would be sent to backend
    // For demo, we'll add to our local list
    DummyData.screeningResults.add(screening);
    _loadUserScreenings();
    notifyListeners();
  }

  // Get user by role
  UserProfile? getUserByRole(String role) {
    return DummyData.getUserByRole(role);
  }

  // Switch user role (for demo purposes)
  void switchUserRole(String role) {
    final currentUser = DummyData.getUserByRole(role);
    if (currentUser != null) {
      _currentUser = currentUser;
      _loadUserData();
      notifyListeners();
    }
  }

  // Get abnormal results count
  int get abnormalResultsCount {
    return _userScreenings.where((s) => 
      s.status == 'abnormal' || s.status == 'follow_up_needed'
    ).length;
  }

  // Get total screenings count
  int get totalScreeningsCount {
    return _userScreenings.length;
  }

  // Get health access points by type
  List<HealthAccessPoint> getAccessPointsByType(String type) {
    return _healthAccessPoints.where((point) => point.type == type).toList();
  }

  // Get nearby health access points (simplified - just return all for demo)
  List<HealthAccessPoint> getNearbyAccessPoints() {
    return _healthAccessPoints.where((point) => point.isActive).toList();
  }

  // Redeem reward
  void redeemReward(RewardItem reward) {
    if (_currentUser != null && _currentUser!.points >= reward.pointsRequired) {
      // In a real app, this would update the backend
      // For demo, we'll just remove from available rewards
      _availableRewards.removeWhere((r) => r.id == reward.id);
      notifyListeners();
    }
  }

  // Add points to user (for achievements, screenings, etc.)
  void addPoints(int points) {
    if (_currentUser != null) {
      // In a real app, this would update the backend
      // For demo, we'll just update the local user
      final updatedUser = UserProfile(
        name: _currentUser!.name,
        phoneNumber: _currentUser!.phoneNumber,
        role: _currentUser!.role,
        points: _currentUser!.points + points,
        age: _currentUser!.age,
        location: _currentUser!.location,
        interests: _currentUser!.interests,
      );
      _currentUser = updatedUser;
      _loadAvailableRewards();
      notifyListeners();
    }
  }

  // Check if user is youth
  bool get isYouth => _currentUser?.role == 'youth';

  // Check if user is staff
  bool get isStaff => _currentUser?.role == 'staff';

  // Check if user is peer navigator
  bool get isPeerNavigator => _currentUser?.role == 'peer_navigator';

  // Check if user is vendor
  bool get isVendor => _currentUser?.role == 'vendor';

  // Get user's role display name
  String get userRoleDisplayName {
    switch (_currentUser?.role) {
      case 'youth':
        return 'Youth';
      case 'staff':
        return 'Health Worker';
      case 'peer_navigator':
        return 'Peer Navigator';
      case 'vendor':
        return 'Market Vendor';
      default:
        return 'User';
    }
  }

  // Mark notification as read
  void markNotificationAsRead(String notificationId) {
    final notification = _userNotifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => throw Exception('Notification not found'),
    );
    
    // Create a new notification with isRead = true
    final updatedNotification = NotificationItem(
      id: notification.id,
      title: notification.title,
      message: notification.message,
      type: notification.type,
      timestamp: notification.timestamp,
      isRead: true,
      relatedId: notification.relatedId,
      action: notification.action,
    );
    
    // Replace the old notification
    final index = _userNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _userNotifications[index] = updatedNotification;
      notifyListeners();
    }
  }

  // Mark all notifications as read
  void markAllNotificationsAsRead() {
    for (int i = 0; i < _userNotifications.length; i++) {
      final notification = _userNotifications[i];
      final updatedNotification = NotificationItem(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        timestamp: notification.timestamp,
        isRead: true,
        relatedId: notification.relatedId,
        action: notification.action,
      );
      _userNotifications[i] = updatedNotification;
    }
    notifyListeners();
  }
}
