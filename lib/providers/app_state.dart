// App state management using Provider
// This file manages the global state of the AfyaLink Market app

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

  // Constructor - initialize with default data
  AppState() {
    _initializeData();
  }

  // Initialize app data
  void _initializeData() {
    // Set default user (John Doe - visitor)
    _currentUser = DummyData.currentUser;
    _isLoggedIn = true;
    
    // Load user screenings
    _loadUserScreenings();
    
    // Load available rewards
    _loadAvailableRewards();
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
    _loadUserScreenings();
    _loadAvailableRewards();
    notifyListeners();
  }

  // Logout
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    _userScreenings.clear();
    _availableRewards.clear();
    _currentScreenIndex = 0;
    notifyListeners();
  }

  // Change current screen
  void setCurrentScreen(int index) {
    _currentScreenIndex = index;
    notifyListeners();
  }

  // Load user screenings based on current user
  void _loadUserScreenings() {
    if (_currentUser != null) {
      if (_currentUser!.role == 'visitor') {
        // For visitors, show screenings with their phone number
        _userScreenings = DummyData.getScreeningsByPhone(_currentUser!.phoneNumber);
      } else {
        // For champions, show all screenings they've recorded
        _userScreenings = DummyData.screeningResults;
      }
    }
  }

  // Load available rewards for current user
  void _loadAvailableRewards() {
    if (_currentUser != null) {
      _availableRewards = DummyData.getAvailableRewards(_currentUser!.points);
    }
  }

  // Add new screening (for champions)
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
    final user = DummyData.getUserByRole(role);
    if (user != null) {
      _currentUser = user;
      _loadUserScreenings();
      _loadAvailableRewards();
      notifyListeners();
    }
  }

  // Get abnormal results count
  int get abnormalResultsCount {
    return _userScreenings.where((s) => s.status == 'abnormal').length;
  }

  // Get total screenings count
  int get totalScreeningsCount {
    return _userScreenings.length;
  }
}
