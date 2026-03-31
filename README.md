# Task Manager

A Flutter task management app with a polished mobile-first UI, local SQLite persistence, and GetX-based state management, navigation, and dependency injection.

## Features

- Custom animated splash screen
- Home screen with:
  - scrolling sliver app bar
  - debounced task search
  - normal, blocked, and completed task states
- Task creation and editing
- Task dependencies with `blocked by` relationships
- SQLite persistence with task CRUD operations
- Task details screen with custom designed layout
- Completed tasks remain visible on the home screen for 24 hours

## Tech Stack

- Flutter
- Dart
- GetX
- sqflite
- google_fonts
- intl

## Project Structure

```text
lib/
  main.dart
  model/
    task_model.dart
  services/
    database_service.dart
    home_ui_controller.dart
    task_controller.dart
  screen/
    splash_screen.dart
    home_view.dart
    home_details_view.dart
    task/
      add_task_view.dart
      task_details_page.dart
      widget/
        task_card.dart
        edit_task_popup.dart
        delete_task_popup.dart
        update_status_bottomsheet.dart
  widget/
    app_logo.dart
```

## State Management With GetX

This app uses GetX in three main ways:

### 1. Dependency Injection

GetX controllers are registered in [main.dart](/Users/swastik/Projects/task_manager/lib/main.dart) using `Get.lazyPut(...)`.

- `TaskController`
  - owns task data
  - handles CRUD operations
  - manages search, filtering, blocked task logic, and form state
- `HomeUiController`
  - controls the animated floating action button on the home screen

Because these controllers are lazily injected, they are created only when first needed.

### 2. Reactive State

The app uses GetX reactive variables like:

- `RxList<TaskModel>` for `tasks` and `filteredTasks`
- `RxBool` for loading and saving states
- `RxString` / `RxnString` for search and errors
- `Rx<TaskStatus>` and `Rxn<DateTime>` for form selections

UI screens listen to these values with `Obx(...)`, so the interface updates automatically without relying on `setState`.

Examples:

- [home_view.dart](/Users/swastik/Projects/task_manager/lib/screen/home_view.dart)
  listens to task lists, search state, and FAB animation state
- [task_details_page.dart](/Users/swastik/Projects/task_manager/lib/screen/task/task_details_page.dart)
  reacts to changes in the selected task record
- [add_task_view.dart](/Users/swastik/Projects/task_manager/lib/screen/task/add_task_view.dart)
  reacts to current form values and save state

### 3. Navigation

The app uses GetX navigation instead of `Navigator`.

Examples:

- `Get.to(...)` for opening screens
- `Get.off(...)` for replacing the splash screen
- `Get.dialog(...)` for edit/delete dialogs
- `Get.bottomSheet(...)` for status updates
- `Get.back(...)` for closing overlays and returning results

This keeps screen flow consistent across the app.

## TaskController Responsibilities

[task_controller.dart](/Users/swastik/Projects/task_manager/lib/services/task_controller.dart) is the main app controller.

It is responsible for:

- loading tasks from SQLite
- creating, updating, deleting, and searching tasks
- managing blocked task dependencies
- determining whether a task is actively blocked
- maintaining `filteredTasks` for the home screen
- handling completed task visibility for 24 hours
- providing form controllers for add/edit flows
- debouncing search input

## Database Layer

[database_service.dart](/Users/swastik/Projects/task_manager/lib/services/database_service.dart) wraps the local SQLite database.

It handles:

- database initialization
- schema upgrades
- task insert, fetch, search, update, and delete operations
- debug print logs for database activity

The `tasks` table stores:

- `id`
- `title`
- `description`
- `dueDate`
- `status`
- `blockedBy`
- `completedAt`

## Installation

1. Clone the repository

```bash
git clone <your-repository-url>
cd task_manager
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app

```bash
flutter run
```

## Useful Commands

Run the app:

```bash
flutter run
```

Analyze the project:

```bash
flutter analyze
```

Format the project:

```bash
dart format .
```

Build release APK:

```bash
flutter build apk
```

## Notes

- The app seeds a few sample tasks automatically when the local database is empty.
- Search on the home screen is debounced before querying the database.
- Blocked tasks are styled differently and cannot be opened until their dependency task is completed.
<img width="300" height="500" alt="Screenshot_1774959667" src="https://github.com/user-attachments/assets/ca8e8f65-3994-43cf-8f6d-6fa798fe0e2e" />
<img width="300" height="500" alt="Screenshot_1774959656" src="https://github.com/user-attachments/assets/e101b1cf-364d-48c6-961a-110371ae8e89" />


## Assets

Local assets are stored in:

```text<img width="1080" height="2400" alt="Screenshot_1774959659" src="https://github.com/user-attachments/assets/07483c30-167a-4492-bc39-32891e015e1d" />

assets/images/
```

They are declared in [pubspec.yaml](/Users/swastik/Projects/task_manager/pubspec.yaml).
## 🤖 AI Usage Report

This project was developed with the assistance of AI tools to enhance productivity, improve code quality, and support architectural decisions.

---

### 🧠 AI Tools Used

- **ChatGPT (OpenAI)** – Used for guidance in architecture, debugging, and implementation strategies  
- **IDE AI Assistants** – Used for code suggestions and minor optimizations  

---

### ⚙️ Scope of AI Assistance

#### 1. Architecture & Design
- Assisted in structuring the application using **GetX architecture**
- Helped define clean separation between:
  - Controllers
  - Services
  - Database layer

---

#### 2. Feature Development
AI was used as a **support tool** while implementing:

- Task CRUD operations (Create, Read, Update, Delete)
- Search and filtering logic (status, date, priority)
- Task status management (Done / In Progress / Pending)
- State management using GetX
- Local database integration (sqflite / Hive)

---

#### 3. Debugging & Issue Resolution
- Assisted in identifying and resolving runtime issues
- Helped fix UI inconsistencies and state-related bugs
- Provided solutions for platform-specific issues

---

#### 4. Code Improvement
- Suggested better code structure and organization
- Helped improve readability and maintainability
- Assisted in refactoring components for scalability

---

#### 5. Documentation Support
- Assisted in writing and improving:
  - README.md
  - Setup instructions
  - Project structure documentation

---




### 🚀 Impact

- ⚡ Faster development cycle  
- 🧹 Cleaner and more structured code  
- 🧠 Improved understanding of architecture patterns  
- 🛠 Enhanced debugging efficiency  
