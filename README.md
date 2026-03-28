# Task Manager

A Flutter-based task management app focused on a clean, modern mobile UI and a simple productivity experience.

The project currently includes a custom-designed splash screen, themed typography, local image assets, and the base app structure for growing the product further.

## Overview

This project is being built as a task management application where users can organize work, track daily routines, and manage productivity flows in a clean interface.

At the moment, the app includes:

- A custom splash screen UI
- Reusable app theme configuration
- Asset-based branding and illustrations
- A starter home screen for further feature development

## Tech Stack

Current stack used in the codebase:

- Flutter
- Dart
- Material Design
- `google_fonts`

Planned / intended stack:

- GetX for state management, navigation, and dependency injection

Note:
GetX is not yet integrated into the current source code. If you want, it can be added in the next step.

## Project Structure

```text
lib/
  main.dart
  screen/
    splash_screen.dart
    home_view.dart

assets/
  images/
```

## Setup

### Prerequisites

Make sure you have the following installed:

- Flutter SDK
- Dart SDK
- Android Studio / VS Code
- An Android emulator, iOS simulator, or physical device

## Installation

1. Clone the repository:

```bash
git clone <your-repository-url>
cd task_manager
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Useful Commands

Run the project:

```bash
flutter run
```

Analyze the code:

```bash
flutter analyze
```

Format the code:

```bash
dart format .
```

Build release APK:

```bash
flutter build apk
```

## Current UI Notes

- The splash screen uses custom-painted blurred ellipse backgrounds
- Typography uses `Manrope` for headings and `Inter` for body content
- Local image assets are used from `assets/images/`

## Roadmap

Planned improvements for the project:

- Add GetX architecture
- Build task list and task detail flows
- Add local persistence
- Add onboarding and authentication
- Improve home screen design and interactions

## Assets

The app currently uses local image assets stored in:

```text
assets/images/
```

Make sure assets are declared in [`pubspec.yaml`](/Users/swastik/Projects/task_manager/pubspec.yaml).

## Author

Built with Flutter and Dart as a foundation for a task management app.
