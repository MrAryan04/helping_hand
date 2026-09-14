# Helping Hand — Community Support App

A Flutter app that connects people who need help with volunteers in their community — a full-stack mobile project with a real-time backend.

## Features
- **Auth** — user registration & login (Firebase Auth)
- **Posts & feeds** — community posts with images (Cloud Firestore + Firebase Storage)
- **Live chat & video calls** — 1-to-1 messaging with ZegoCloud UIKit call integration
- **Notifications** — push notifications with Firebase Messaging
- **Location** — address & geolocation support via geocoding
- **Admin panel** — separate admin role for moderation
- **Profiles** — user profiles with settings

## Tech
Flutter · Dart · Firebase (Auth, Firestore, Storage, Messaging) · ZegoCloud · Geocoding

## Run it
```
flutter pub get
flutter run
```
Requires a Firebase project with Auth, Firestore, Storage and Messaging configured.
