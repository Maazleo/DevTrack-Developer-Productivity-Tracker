import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class AppColors {
  static const darkBlue = Color(0xFF1A4D8C);
  static const lightBlue = Color(0xFF64B5F6);
  static const background = Color(0xFFF5F7FA);
  static const darkBackground = Color(0xFF121212);
  static const cardDark = Color(0xFF1E1E2C);
}

class AppConstants {
  static const appName = 'DevTrack';
  static const pomodoroWorkDuration = 25; // minutes
  static const pomodoroBreakDuration = 5; // minutes
}

List<Map<String, dynamic>> dummyTasks = [
  {
    'id': '1',
    'title': 'Fix login bug',
    'isCompleted': false,
  },
  {
    'id': '2',
    'title': 'Push to GitHub',
    'isCompleted': true,
  },
  {
    'id': '3',
    'title': 'Refactor UI buttons',
    'isCompleted': false,
  },
  {
    'id': '4',
    'title': 'Update documentation',
    'isCompleted': false,
  },
];

// Sample user profile - made mutable so it can be updated
var sampleUserProfile = UserProfile(
  id: 'user123',
  name: 'Maaz Ahmed',
  email: 'maaz@example.com',
  phone: '+1234567890',
  location: 'New York, USA',
  bio: 'Frontend developer specializing in Flutter and React Native applications. Passionate about clean code and beautiful UI.',
  profileImageUrl: null, // We'll use initials instead
  jobTitle: 'Senior Flutter Developer',
  company: 'DevTrack Solutions',
  skills: ['Flutter', 'Dart', 'Firebase', 'React Native', 'UI/UX Design'],
  socialLinks: {
    'github': 'https://github.com/maaz',
    'linkedin': 'https://linkedin.com/in/maaz',
    'twitter': 'https://twitter.com/maaz'
  },
  website: 'https://maazportfolio.dev',
  preferences: {
    'theme': 'system',
    'notifications': 'enabled',
    'language': 'en'
  },
  joinDate: DateTime(2023, 6, 15),
); 