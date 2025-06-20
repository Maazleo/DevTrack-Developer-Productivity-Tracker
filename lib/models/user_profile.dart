class UserProfile {
  String id;
  String name;
  String email;
  String? phone;
  String? location;
  String? bio;
  String? profileImageUrl;
  String? jobTitle;
  String? company;
  List<String>? skills;
  Map<String, dynamic>? socialLinks;
  String? website;
  Map<String, String>? preferences;
  DateTime? joinDate;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.location,
    this.bio,
    this.profileImageUrl,
    this.jobTitle,
    this.company,
    this.skills,
    this.socialLinks,
    this.website,
    this.preferences,
    this.joinDate,
  });

  // Convert to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'jobTitle': jobTitle,
      'company': company,
      'skills': skills,
      'socialLinks': socialLinks,
      'website': website,
      'preferences': preferences,
      'joinDate': joinDate?.toIso8601String(),
    };
  }

  // Create from a Map (e.g., when loading from storage)
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      location: map['location'],
      bio: map['bio'],
      profileImageUrl: map['profileImageUrl'],
      jobTitle: map['jobTitle'],
      company: map['company'],
      skills: map['skills'] != null ? List<String>.from(map['skills']) : null,
      socialLinks: map['socialLinks'],
      website: map['website'],
      preferences: map['preferences'] != null ? Map<String, String>.from(map['preferences']) : null,
      joinDate: map['joinDate'] != null ? DateTime.parse(map['joinDate']) : null,
    );
  }

  // Create a copy of the profile with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    String? bio,
    String? profileImageUrl,
    String? jobTitle,
    String? company,
    List<String>? skills,
    Map<String, dynamic>? socialLinks,
    String? website,
    Map<String, String>? preferences,
    DateTime? joinDate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      skills: skills ?? this.skills,
      socialLinks: socialLinks ?? this.socialLinks,
      website: website ?? this.website,
      preferences: preferences ?? this.preferences,
      joinDate: joinDate ?? this.joinDate,
    );
  }
} 