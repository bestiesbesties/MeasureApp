
# Measure App

The **Measure App** is a mobile Flutter application designed to work seamlessly with a physical **measure mat**. It collects body measurement data and sends it to a database for further processing and analysis.

## 📱 About the App

This app is intended for use with a physical mat that includes sensors and a laser measurement system. Users are guided through a short onboarding process when opening the app for the first time. The app:

- Ensures users stand on the mat with the correct posture
- Verifies position using the mat’s built-in sensors
- Triggers a laser-based system to accurately measure the user’s height
- Sends the collected data to a remote database

## 🧭 Features

- First-time user guide to prepare for mat usage
- Real-time posture verification through AI-model
- Laser-based height measurement
- Sensor-based weight measurement
- Seamless data transmission to a backend system
- Simple and intuitive Flutter UI

## 🚀 Getting Started

> **Note:** This app is intended for use with a compatible measure mat. It will not function fully without the hardware.

### Installation

Currently, the app is distributed as a standard mobile application:

1. Clone the repository (for development purposes):
   ```bash
   git clone https://github.com/yourusername/measure-app.git
   cd measure-app
   ```
2. Open the project in Android Studio or VS Code.
3. Run the app using a connected device or emulator:
   ```bash
   flutter pub get
   flutter run
   ```

> For end users: The final version of the app will be available via a mobile download link or app store listing. *(Not available yet!)*

## 📸 Wireframes

[wireframes](https://github.com/user-attachments/assets/55b86d42-cde1-41f3-9ed1-ba8b0f716401)



## 🛠 Tech Stack

- Flutter
- Bluethooth plus package
- Dart
- Android Studio
- Sensor & Laser integration with external hardware
- Cloud database (e.g., Firebase, Supabase, or custom backend)

