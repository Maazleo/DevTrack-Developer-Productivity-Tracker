import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../utils/user_preferences.dart';
import '../utils/constants.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = true;

  UserProfile get userProfile => _userProfile ?? sampleUserProfile;
  bool get isLoading => _isLoading;

  UserProvider() {
    _loadUserProfile();
  }

  // Load user profile from shared preferences
  Future<void> _loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserProfile? savedProfile = await UserPreferences.getUserProfile();
      
      if (savedProfile != null) {
        _userProfile = savedProfile;
      } else {
        // If no saved profile exists, use the sample profile as default
        _userProfile = sampleUserProfile;
        // Save the sample profile to shared preferences
        await UserPreferences.saveUserProfile(_userProfile!);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      _userProfile = sampleUserProfile;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Update user profile and save to shared preferences
  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    _userProfile = updatedProfile;
    
    // Update the global sample profile for backward compatibility
    sampleUserProfile = updatedProfile;
    
    notifyListeners();
    
    try {
      await UserPreferences.saveUserProfile(updatedProfile);
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  // Reset user profile to default
  Future<void> resetUserProfile() async {
    _userProfile = sampleUserProfile;
    notifyListeners();
    
    try {
      await UserPreferences.clearUserProfile();
      await UserPreferences.saveUserProfile(sampleUserProfile);
    } catch (e) {
      debugPrint('Error resetting user profile: $e');
    }
  }
} 