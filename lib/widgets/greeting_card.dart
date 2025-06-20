import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import 'weather_info.dart';

class GreetingCard extends StatefulWidget {
  final UserProfile user;
  final VoidCallback? onTap;

  const GreetingCard({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getMotivationalQuote() {
    final quotes = [
      "Focus on being productive instead of busy.",
      "The key is not to prioritize what's on your schedule, but to schedule your priorities.",
      "Do the hard jobs first. The easy jobs will take care of themselves.",
      "You don't need more hours in the day, you need a clearer focus.",
      "Start where you are. Use what you have. Do what you can.",
    ];
    // Return a random quote based on the current day
    return quotes[DateTime.now().day % quotes.length];
  }

  // Mock weather data - in a real app, this would come from an API
  IconData _getWeatherIcon() {
    final icons = [
      Icons.wb_sunny_outlined,
      Icons.cloud_outlined,
      Icons.grain,
    ];
    return icons[DateTime.now().hour % icons.length];
  }

  String _getWeatherCondition() {
    final conditions = ['Sunny', 'Cloudy', 'Rainy'];
    return conditions[DateTime.now().hour % conditions.length];
  }

  String _getTemperature() {
    // Generate a random temperature between 15 and 30 degrees
    return (15 + (DateTime.now().minute % 15)).toString();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.user.name.split(' ').first;
    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, d MMMM');
    final formattedDate = dateFormatter.format(now);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: widget.onTap,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode 
                  ? [
                      theme.colorScheme.primary.withOpacity(0.7),
                      theme.colorScheme.primary.withOpacity(0.4),
                    ]
                  : [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.7),
                    ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode 
                    ? Colors.black.withOpacity(0.5) 
                    : theme.colorScheme.primary.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User avatar
                    Hero(
                      tag: 'user_avatar',
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: widget.user.profileImageUrl != null
                          ? ClipOval(
                              child: Image.network(
                                widget.user.profileImageUrl!,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Text(
                              _getInitials(widget.user.name),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Greeting and Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()},',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            firstName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Date and time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Date
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('d MMM').format(now),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE').format(now),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Weather info
                        WeatherInfo(
                          temperature: _getTemperature(),
                          weatherIcon: _getWeatherIcon(),
                          condition: _getWeatherCondition(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Motivational quote
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getMotivationalQuote(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (name.isNotEmpty) {
      return name[0];
    }
    return 'U';
  }
} 