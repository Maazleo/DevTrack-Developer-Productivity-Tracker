import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool _isRunning = false;
  String _currentMode = "Focus"; // "Focus" or "Break"
  int _remainingMinutes = AppConstants.pomodoroWorkDuration;
  int _remainingSeconds = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _currentMode == "Focus" 
            ? (isDarkMode ? AppColors.darkBlue : AppColors.darkBlue)
            : Colors.green[700],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _currentMode == "Focus" ? Icons.timer : Icons.free_breakfast,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _currentMode == "Focus" ? '🍅 Focus Time' : '☕ Break Time',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              // Mode toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildModeToggle("Focus", _currentMode == "Focus"),
                    _buildModeToggle("Break", _currentMode == "Break"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer display
              Text(
                '$_remainingMinutes:${_remainingSeconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w300,
                ),
              ),
              // Play/Pause button
              IconButton(
                icon: Icon(
                  _isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 52,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isRunning = !_isRunning;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle(String mode, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMode = mode;
          _remainingMinutes = mode == "Focus" 
              ? AppConstants.pomodoroWorkDuration
              : AppConstants.pomodoroBreakDuration;
          _remainingSeconds = 0;
          _isRunning = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          mode,
          style: TextStyle(
            color: isSelected 
                ? _currentMode == "Focus" ? AppColors.darkBlue : Colors.green[700]
                : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
} 