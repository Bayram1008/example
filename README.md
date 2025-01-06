# new_project

This is a flutter project which shows list of employees and their documents. In this project we can add new employees and new documents.

## Table of Contents
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Features](#features)
- [Usage](#usage)

## Getting Started

These instructions will guide you to set up and run the project on your local machine for development and testing purposes.

## Prerequisites
•	- Flutter SDK (3.27.1)
•	- Dart SDK
•	- Android Studio or Xcode for iOS development
•	- An emulator or physical device for testing
## Installation

For installing flutter, follow (https://docs.flutter.dev/get-started/)

For installing project, follow next steps:

1. **Clone the Repository**
```bash
https://git.tmcars.info/intern/hrmanagement.git

cd flutter_application_1
```
2. **Install Dependencies**
Run the following command to fetch and install the dependencies:
```bash
flutter pub get
```
3. **Run the App**
Connect your emulator or physical device, then use this command to run the app:
```bash
flutter run
```
minSdkVersion is in the path ../android/app/src/build.gradle 
## Project Structure

    lib/
    ├── main.dart                   # Main entry point
        api/                        # Working with Server
            get_data.dart           # Get request
            savedata.dart           # Save tokens
    ├── pages/                      # Contains all screens
    │   ├── login_page.dart         # Login screen
    │   ├── user_list.dart          # Employee list screen
    │   └── user_info.dart          # Employee details screen
            all_documents.dart      # All documents screen
            doc_info.dart           # Document information screen
            edit_document.dart      # Editting document screen
            employee_doc.dart       # Employee documents screen
            new_document.dart       # Adding new document screen
            new_user.dart           # Adding new employee screen
            splash_screen.dart      # Splash screen
            translation.dart        # Translation screen
            update_employee.dart    # Editting employee screen
            user_prof.dart          # User Profile screen
    ├── models/                     # Data models
    │   └── user_model.dart         # Employee data model

## Features
•	- **User Login**: Secure login functionality for users
•	- **Employee List**: A page that displays a list of all employees
•	- **Employee Documents**: Upon selecting an employee, the app displays personal documents for that employee.
## Usage
**Login** - Open the app and log in with your credentials.
**View Employee List** - After logging in, you will see a list of employees with basic details.
**View Employee Documents** - Click on any employee to access their personal documents and their information.
