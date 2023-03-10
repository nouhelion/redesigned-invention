# Gestion des Cotisations Au Sein d'un Groupe app using Flutter and Firebase
Flutter app for managing membership fees within a group

## Getting Started
It is a complete app for managing membership fees within a group, designed using Flutter. It uses Firebase as a backend for CRUD operations.

## Tools Used
* Flutter    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img src="https://static-00.iconduck.com/assets.00/flutter-icon-413x512-4picx6vy.png" alt="Flutter" width='18' height='23'>
* Firebase   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img src="https://seeklogo.com/images/F/firebase-logo-402F407EE0-seeklogo.com.png" alt="Firebase" width='18' height='28'>


## Steps to Reproduce the Project in Your Environment
   * Download and set up the Flutter SDK.
   * Install the Flutter plugin in your editor (preferably Visual Studio Code).
   * Create your own Firebase project and make sure that the package name in the Firebase app is the same as the application ID in the Android gradle file.
   * Download the google-services.json file and paste it inside the /android/app directory.
   * Run flutter pub get to download the dependencies.
   * Press the run button in Android Studio to install the APK.
   * The project will now be running on your device.

## Features of This Flutter App

   - Home

      * Overview of membership fees
      * List of members and their fees

   - Trips
      
      * Add a trip
      * Add list of members with the task assigned to them  
   
   - Members

      * List of members
      * Member details view
      * Add a new member
      * Add Tasks

   - Fees

      * List of fees
      * Fee details view
      * Add a new fee

   - Profile

      * Account details
      * Edit profile details

   - Authentication

      * Registration with email and password
      * Login with email and password
      * Logout

   - Backend

      * Database system with Firebase Firestore
      * User management with Firebase Authentication
