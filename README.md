# 📝 Task Manager App

A modern **Flutter-based task management application** built with **GetX architecture**, local persistence, and powerful productivity features like search, filtering, and task status tracking.

---

## 🚀 Overview

This application helps users manage daily tasks efficiently with:

* Structured task organization
* Real-time search & filtering
* Status-based workflow tracking
* Persistent local storage

The app is designed with **clean architecture principles** and is scalable for production use.

---

## ✨ Features

### 🧱 Core Architecture

* ✅ Full **GetX architecture**

  * Bindings
  * Controllers
  * Services
  * Dependency Injection

---

### 📝 Task Management

* ✅ Create tasks
* ✅ Update tasks
* ✅ Delete tasks
* ✅ View all tasks

---

### 💾 Local Persistence

* ✅ Integrated **sqflite / Hive** database
* ✅ Offline-first functionality
* ✅ Fast local data access

---

### 🔍 Search & Filtering

* ✅ Search tasks by title/description
* ✅ Filter by:

  * Status (Done / In Progress / Pending)
  * Date
  * Priority (if implemented)

---

### 📌 Task Status System

* ✅ Mark tasks as:

  * Done
  * In Progress
  * Pending
* ✅ Dynamic UI updates using GetX reactivity

---

### 🎨 UI & UX

* ✅ Clean and modern UI
* ✅ Custom splash screen
* ✅ Themed typography (Manrope + Inter)
* ✅ Responsive layouts

---

## 🛠️ Tech Stack

* **Framework:** Flutter
* **Language:** Dart
* **State Management:** GetX
* **Database:** sqflite / Hive
* **Architecture:** Clean Architecture (Controller → Service → DB)
* **UI:** Material Design + Custom Styling

---

## 📂 Project Structure

```text
lib/
  bindings/
  controllers/
  services/
  models/
  views/

  main.dart
```

---

## 🧠 Architecture Overview

```text
UI (Views)
   ↓
GetX Controller
   ↓
Service Layer
   ↓
Local Database (sqflite / Hive)
```

---

## 🧪 Testing & Quality

* Unit tests for controllers
* Widget tests for UI interactions
* Ready for CI/CD integration (GitHub Actions)

---

## ⚙️ Setup & Installation

```bash
git clone <your-repository-url>
cd task_manager
flutter pub get
flutter run
```

---

## 🧭 Roadmap (Next Steps)

* [ ] Notifications & reminders
* [ ] Cloud sync (Firebase / Supabase)
* [ ] User authentication
* [ ] Dark mode
* [ ] Performance optimizations
* [ ] App Store / Play Store deployment

---

## 📌 Highlights

* Built with **scalable architecture**
* Uses **reactive state management (GetX)**
* Supports **offline-first task management**
* Designed for **real-world production use**

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit PRs.

---

## 📄 License

MIT License

---

## 💡 Author

Built with ❤️ using Flutter to explore production-grade mobile app development.
