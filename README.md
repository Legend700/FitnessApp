# ABXFIT - Fitness App

ABXFIT is a comprehensive fitness application designed for everyone. It helps users track their workouts, log meals, and receive AI-powered workout recommendations. The app is built with Flutter, allowing it to run seamlessly on both iOS and Android devices.

## Features

- **User Authentication**: Allows users to sign up and log in with email and password.
- **Workout Tracking**: Users can log their workouts, including type and duration.
- **Meal Logging**: Users can log their meals along with calories.
- **AI Recommendations**: Personalized workout recommendations based on user activity and fitness level.

## Technologies Used

- **Flutter**: A UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- **Firebase**:
  - **Firebase Authentication**: For user sign-up and login functionality.
  - **Firestore**: For storing user data such as workouts and meals.
- **AI Tools**:
  - **TensorFlow Lite / OpenAI**: For providing AI-powered workout recommendations (to be integrated).

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your_username/ABXFIT.git
    ```
   
2. **Install dependencies**:
    Navigate to the project directory and run:
    ```bash
    flutter pub get
    ```

3. **Set up Firebase**:
    - Create a Firebase project at https://console.firebase.google.com.
    - Set up Firebase Authentication and Firestore.
    - Add the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to your project’s `android` and `ios` folders.

4. **Run the app**:
    Use the following command to run the app on your emulator or connected device:
    ```bash
    flutter run
    ```

## Contributing

If you would like to contribute to ABXFIT, feel free to fork the repository and submit pull requests. Contributions are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
