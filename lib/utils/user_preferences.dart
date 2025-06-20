import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserPreferences {
  static const String _userProfileKey = 'user_profile';
  
  // Save user profile to shared preferences
  static Future<bool> saveUserProfile(UserProfile userProfile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(userProfile.toMap());
    return prefs.setString(_userProfileKey, userJson);
  }
  
  // Get user profile from shared preferences
  static Future<UserProfile?> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_userProfileKey);
    
    if (userJson == null) {
      return null;
    }
    
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserProfile.fromMap(userMap);
  }
  
  // Clear user profile from shared preferences
  static Future<bool> clearUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userProfileKey);
  }
} 