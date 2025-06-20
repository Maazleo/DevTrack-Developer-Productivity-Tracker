import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import '../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // We'll use the profile from UserProvider
  late UserProfile _userProfile;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  // Form controllers
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _websiteController;
  
  List<String> _skills = [];
  final TextEditingController _skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // We'll initialize the controllers in didChangeDependencies
    // to ensure we have access to the Provider
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProfile = userProvider.userProfile;
    _initControllers();
    _skills = _userProfile.skills ?? [];
  }

  void _initControllers() {
    _nameController = TextEditingController(text: _userProfile.name);
    _emailController = TextEditingController(text: _userProfile.email);
    _phoneController = TextEditingController(text: _userProfile.phone ?? '');
    _locationController = TextEditingController(text: _userProfile.location ?? '');
    _bioController = TextEditingController(text: _userProfile.bio ?? '');
    _jobTitleController = TextEditingController(text: _userProfile.jobTitle ?? '');
    _companyController = TextEditingController(text: _userProfile.company ?? '');
    _websiteController = TextEditingController(text: _userProfile.website ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _jobTitleController.dispose();
    _companyController.dispose();
    _websiteController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveProfile,
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                _buildProfileHeader(),
                const SizedBox(height: 24),
                
                // Basic Information
                _buildSectionHeader('Basic Information'),
                _buildInfoSection([
                  _buildTextField(
                    'Full Name', 
                    _nameController, 
                    prefixIcon: Icons.person,
                    isRequired: true,
                  ),
                  _buildTextField(
                    'Email', 
                    _emailController, 
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                  ),
                  _buildTextField(
                    'Phone Number', 
                    _phoneController, 
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    'Location', 
                    _locationController, 
                    prefixIcon: Icons.location_on,
                  ),
                ]),
                
                const SizedBox(height: 16),
                
                // Professional Information
                _buildSectionHeader('Professional'),
                _buildInfoSection([
                  _buildTextField(
                    'Job Title', 
                    _jobTitleController, 
                    prefixIcon: Icons.work,
                  ),
                  _buildTextField(
                    'Company', 
                    _companyController, 
                    prefixIcon: Icons.business,
                  ),
                  _buildTextField(
                    'Website', 
                    _websiteController, 
                    prefixIcon: Icons.web,
                    keyboardType: TextInputType.url,
                  ),
                ]),
                
                const SizedBox(height: 16),
                
                // Bio
                _buildSectionHeader('Bio'),
                _buildInfoSection([
                  _buildTextField(
                    'About Me', 
                    _bioController, 
                    prefixIcon: Icons.description,
                    maxLines: 5,
                  ),
                ]),
                
                const SizedBox(height: 16),
                
                // Skills
                _buildSectionHeader('Skills'),
                _buildSkillsSection(),
                
                const SizedBox(height: 16),
                
                // Social Links
                _buildSectionHeader('Social Links'),
                _buildSocialLinksSection(),
                
                const SizedBox(height: 16),
                
                // Account Info
                _buildSectionHeader('Account Information'),
                _buildAccountInfoSection(),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          // Profile Image
          GestureDetector(
            onTap: _isEditing ? () => _showImageSourceBottomSheet() : null,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: _userProfile.profileImageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            _userProfile.profileImageUrl!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          _getInitials(_userProfile.name),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Name and Job Title
          if (!_isEditing) ...[
            Text(
              _userProfile.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _userProfile.jobTitle ?? 'No job title',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _userProfile.company ?? 'No company',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildInfoSection(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? prefixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isEditing
          ? TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                labelText: label,
                prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
                border: const OutlineInputBorder(),
              ),
              validator: isRequired
                  ? (value) {
                      if (value == null || value.isEmpty) {
                        return '$label is required';
                      }
                      return null;
                    }
                  : null,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(prefixIcon, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        controller.text.isEmpty ? 'Not provided' : controller.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.text.isEmpty ? Colors.grey : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSkillsSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        labelText: 'Add Skill',
                        hintText: 'Enter a skill and press +',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      final skill = _skillController.text.trim();
                      if (skill.isNotEmpty) {
                        setState(() {
                          _skills.add(skill);
                          _skillController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
                  deleteIcon: _isEditing ? const Icon(Icons.close, size: 18) : null,
                  onDeleted: _isEditing
                      ? () {
                          setState(() {
                            _skills.remove(skill);
                          });
                        }
                      : null,
                );
              }).toList(),
            ),
            if (_skills.isEmpty && !_isEditing)
              const Text(
                'No skills added yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinksSection() {
    final socialLinks = _userProfile.socialLinks ?? {};
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isEditing)
              const Text('Social links editing will be implemented in a future update'),
            if (!_isEditing) ...[
              _buildSocialLinkRow('GitHub', socialLinks['github'], Icons.code),
              _buildSocialLinkRow('LinkedIn', socialLinks['linkedin'], Icons.business_center),
              _buildSocialLinkRow('Twitter', socialLinks['twitter'], Icons.chat_bubble_outline),
              if (socialLinks.isEmpty)
                const Text(
                  'No social links added yet',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinkRow(String platform, String? url, IconData icon) {
    if (url == null || url.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            platform,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              url,
              style: TextStyle(
                color: Colors.blue[700],
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoSection() {
    final joinDate = _userProfile.joinDate != null
        ? DateFormat('MMMM d, yyyy').format(_userProfile.joinDate!)
        : 'Unknown';
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                const Text('Joined: '),
                Text(
                  joinDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!_isEditing)
              ElevatedButton.icon(
                icon: const Icon(Icons.security),
                label: const Text('Change Password'),
                onPressed: () {
                  // In a real app, navigate to password change screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password change functionality will be added later')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, add camera functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera functionality will be added later')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // In a real app, add gallery functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery functionality will be added later')),
                  );
                },
              ),
              if (_userProfile.profileImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove photo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _userProfile = _userProfile.copyWith(profileImageUrl: null);
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = _userProfile.copyWith(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        location: _locationController.text,
        bio: _bioController.text,
        jobTitle: _jobTitleController.text,
        company: _companyController.text,
        website: _websiteController.text,
        skills: _skills,
      );
      
      // Update the profile using the provider
      Provider.of<UserProvider>(context, listen: false).updateUserProfile(updatedProfile);
      
      setState(() {
        _userProfile = updatedProfile;
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (name.isNotEmpty) {
      return name[0];
    } else {
      return 'U';
    }
  }
}