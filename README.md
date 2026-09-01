
# 🔦 Flashlight Controller App

A sleek, modern, and high-performance Flashlight application built with **Flutter**. This app allows users to turn their device's LED camera flash into a digital torchlight with real-time brightness/intensity control.

---

## ✨ Features

* **One-Tap Power Toggle:** Smooth animated power button to quickly turn the flashlight ON and OFF.
* **Brightness / Intensity Control:** Adjust flashlight intensity using an intuitive slider (supported on compatible hardware).
* **Modern UI/UX:** Clean dark mode interface with interactive visual glowing effects.
* **Optimized Performance:** Efficient resource cleanup and safe state management to prevent battery drain.
* **Cross-Platform Ready:** Supports both Android and iOS devices.

---

## 📸 Screenshots

|  Flashlight OFF   |  Flashlight ON   |
|:-----------------:|:----------------:|
| *(screenshot 1 )* | *(screenshot 2)* |

---

## 🚀 Getting Started

Follow these instructions to set up and run the project locally.

### Prerequisites

Ensure you have the following installed on your development machine:
* **Flutter SDK:** `>=3.0.0`
* **Dart SDK:** `>=3.0.0`
* **Android Studio** or **VS Code** with Flutter extensions.

### Installation

1. **Clone the Repository:**
   ```bash
   git clone [https://github.com/your-username/flashlight_app.git](https://github.com/your-username/flashlight_app.git)
2. Navigate to the project Directory 
   Bash 
   cd flashlight_app

3. Install Depandencies:
   Bash
   flutter pub get

4. Run the App:
   Bash
   flutter run

🛠️ Required Permissions
Android

Make sure the following permissions are present in your android/app/src/main/AndroidManifest.xml:
XML

<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.FLASHLIGHT" />

<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-feature android:name="android.hardware.camera.flash" android:required="false" />

iOS

Add the following key to your ios/Runner/Info.plist:
XML

<key>NSCameraUsageDescription</key>
<string>Camera access is required to use the device flashlight.</string>

📦 Dependencies

This project utilizes the following key packages:

    camera - Accessing and controlling the device camera flash.

    cupertino_icons - Default icons for iOS-style design elements.

🔒 Security & Build Obfuscation

To build a secure release version of the application and prevent code decompilation, use the Flutter obfuscation flag:
Bash

flutter build apk --release --obfuscation --split-debug-info=build/app/outputs/symbols

📝 License

This project is licensed under the MIT License - see the LICENSE file for details.


<FollowUp label="Want me to help you generate a LICENSE file or GitHub Actions workflow for this project?" query="Help me generate a standard MIT License file text for my Flutter flashlight project."/>