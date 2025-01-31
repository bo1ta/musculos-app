# Musculos - iOS Workout App

Musculos is a sleek, modular SwiftUI application designed for fitness enthusiasts to create personal workouts and track their fitness goals.

This repository contains the iOS frontend of the app, while the backend, built with Vapor, can be found [here](https://github.com/bo1ta/musculos-api).

- Features:
  - Personalized Workouts: Create custom workouts tailored to your fitness goals.
  - Goal Tracking: Set and monitor fitness objectives.
  - Recommendations: Get workout recommendations based on your past sessions, goals, user level, etc
  - Offline-first approach: Rely on the local data store first, fallback to network when needed

- Modules:
  - Storage - provides a thread-safe Core Data integration. `CoreDataStore` is the main entry point for storage operations.
  - DataRepository - acts as a coordinator between `Storage` and `NetworkClient` modules. Coordinates the data synchronization / fetch policy
  - NetworkClient - provides the network layer that interacts with the Vapor API
  - Components - A library of reusable UI components used throughout the app
  - Utility - Common utility functions, extensions, and helpers to simplify development tasks
  - Models - Core data models used in the app


Backend Integration

The backend for Musculos is powered by Vapor, a lightweight and performant Swift server-side framework. See more about the backend [here](https://github.com/bo1ta/musculos-api)


##
##

<img width="320" alt="Screenshot 2025-01-21 at 22 57 48" src="https://github.com/user-attachments/assets/b7543035-5c68-47af-b760-c2a8b2a90e14" />
