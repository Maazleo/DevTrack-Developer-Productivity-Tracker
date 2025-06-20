# 🚀 DevTrack – Developer Productivity Tracker

![Banner](screenshots/banner.png) <!-- Optional: Add a top banner later -->

**DevTrack** is a modern productivity tracker built specifically for developers. Whether you're a freelancer, student, or full-time engineer, DevTrack helps you stay focused, manage tasks, track your coding time, and monitor your daily progress — all in one intuitive Flutter app.

---

## 📱 Live Demo

👉 [**Try DevTrack Live**](#)  
_(Hosted on Flutter Web – Link will be updated soon)_

---

## ✨ Features

### 🧠 Task Management
- Create, edit, delete, and organize coding tasks
- Assign due time, priority (Low, Medium, High), and status
- Daily task tracking with completion streaks
- Beautiful, clean list UI with swipe gestures (planned)

### ⏱️ Pomodoro Focus Timer
- Customizable Pomodoro sessions (default 25/5)
- Daily Pomodoro stats tracking
- Visual timer with animations

### 🕒 Code Time Logging
- Start/stop timers to track actual coding time
- Manual log entry with notes
- Daily and weekly summaries

### 📊 Productivity Dashboard
- View focus time, completed tasks, and Pomodoros for the day
- Productivity score based on effort and goals
- Beautiful charts and insights (weekly trends)

### 🔔 Daily Reminder Notifications
- Optional reminders to start Pomodoro or resume work
- End-of-day summary (planned)

### 🔐 Authentication
- Firebase Auth (Email/Password + Google Sign-In)
- Secure local session management

### 💾 Data Storage
- Offline-first architecture using Hive or Firebase Firestore
- Real-time sync and cloud backup support (optional)

---


---

## 🛠️ Tech Stack

| Layer | Tech |
|-------|------|
| UI | Flutter 3.x |
| State Management | Riverpod / Provider |
| Storage | Hive (offline), Firestore (optional) |
| Charts | `fl_chart` |
| Auth | Firebase Auth |
| Timer | `stop_watch_timer` |
| Notifications | `flutter_local_notifications`, FCM (optional) |
| Platform Support | Android, iOS, Web (Beta) |

---

## 📁 Folder Structure

