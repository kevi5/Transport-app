
# Transport System App

A real-time bus tracking system developed for IIT Goa to enhance the campus transportation experience. The app suite includes three distinct applications catering to different user groups—riders, drivers, and administrators—each with its unique functionality and user interface.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technologies Used](#technologies-used)
4. [Installation](#installation)
5. [Usage](#usage)
6. [App Structure](#app-structure)
7. [Contributing](#contributing)
8. [License](#license)
9. [Acknowledgments](#acknowledgments)

## Project Overview

The Transport System App is designed to provide a seamless transportation management experience on large campuses like IIT Goa. It replaces Google Maps with an open-source alternative, `flutter_map`, to offer a lightweight, customizable, and cost-effective mapping solution. The system includes three applications:

1. **Rider App**: Provides real-time bus tracking, information on nearby stops, and estimated waiting times.
2. **Driver App**: Allows drivers to update their location, manage routes, and communicate with riders.
3. **Administrator App**: Provides tools for managing users, vehicles, routes, and other critical data.

## Features

### Rider App
- Real-time bus tracking with map centering on the user's location.
- Custom markers for landmarks and bus stops.
- Toggle visibility for map elements and landmarks.
- Numbered map markers for easier identification of locations.

### Driver App
- Real-time location updates for drivers.
- Route management tools to optimize trips and reduce waiting times.
- Communication tools to coordinate with riders.

### Administrator App
- Centralized management of users, vehicles, routes, and stops.
- Real-time monitoring of all vehicles and drivers.
- Data analytics tools for improving transportation efficiency.

## Technologies Used

- **Flutter**: A cross-platform UI toolkit for building natively compiled applications for mobile, web, and desktop.
- **Dart**: The programming language used in conjunction with Flutter.
- **Firebase Realtime Database**: A cloud-hosted NoSQL database for managing user and driver locations and real-time updates.
- **Flutter_map**: An open-source mapping solution based on Leaflet.js for flexible and cost-effective map integration.
- **Geolocator**: A plugin for accessing geolocation information on the device.
- **Geocoding Services**: For converting user coordinates into human-readable addresses.

## Installation

To set up the project locally, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/IITGoa/transport-system-app.git
   cd transport-system-app
   ```

2. **Install Flutter**:
   Ensure you have Flutter installed on your machine. Follow the instructions from the [official Flutter website](https://flutter.dev/docs/get-started/install).

3. **Install Dependencies**:
   Navigate to each app directory (rider_app, driver_app, admin_app) and run:
   ```bash
   flutter pub get
   ```

4. **Set Up Firebase**:
   Configure Firebase for each app by adding the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) in their respective directories.

5. **Run the App**:
   Use the following command to run each app on an emulator or physical device:
   ```bash
   flutter run
   ```

## Usage

### Rider App

1. Open the Rider App on your device.
2. Allow location permissions to access real-time tracking features.
3. View nearby bus stops and bus routes.
4. Use the map controls to center on your location or toggle landmarks.

### Driver App

1. Open the Driver App and log in with your credentials.
2. Update your location regularly for real-time synchronization with the Rider App.
3. Use the provided tools to manage routes and communicate with riders.

### Administrator App

1. Open the Administrator App and log in with your admin credentials.
2. Manage users, vehicles, and routes via the dashboard.
3. Monitor real-time data to ensure efficient transportation management.

## App Structure

The project is divided into three main Flutter applications, each with its directory:

- **Rider App**: `/rider_app/`
- **Driver App**: `/driver_app/`
- **Administrator App**: `/admin_app/`

Each app follows a standard Flutter architecture, including directories for:
- **lib/**: Core Flutter/Dart code.
- **assets/**: Images, icons, and other static resources.
- **test/**: Unit and widget tests.

## Contributing

This project is managed by IIT Goa. If you are interested in contributing, please adhere to the following guidelines:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a new Pull Request.

Ensure that your code adheres to the project's coding standards and passes all tests.

## License

This project is licensed under the IIT Goa Software License.

## Acknowledgments

This project was developed as part of the Bachelor Thesis Project (BTP) under the guidance of **Dr. Sharad Sinha** from the Computer Science and Engineering Department at **IIT Goa**. Special thanks to all contributors, faculty, and students who provided valuable feedback and support throughout the development process.
