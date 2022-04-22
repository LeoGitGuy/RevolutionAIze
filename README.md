# Article Reader - Flutter App

This Repo contains the source code for the Article Reader Mobile App, written with the flutter framework in dart.

## Getting Started

For getting started, make sure you have flutter and all necessary additional software installed on your machine
Running
```bash
flutter doctor
```
gives you feedback if you are good to go.

### Launching on IOS

You can launch the app either with an ios simulator or your own device.

1. Simulator

1.1 Open the code in VSC and install the flutter extension.
1.2 Start the simulator (preinstalled on macOS) with
```bash
open -a simulator
```
1.3 In VSC, select the ios simulator in the bottom bar on the right
1.4 Navigate to the [main.dart](lib/main.dart) file in VSC
1.5 In the top bar, hover over *Run* and select *Run without debugging*

2. Your own device

2.1 Make sure you build the flutter application at least one time with 
```bash
flutter build ios
```
2.2 Open the [ios](ios) folder in XCode
2.3 Select the *Runner* on the left side bar with your mouse
2.4 In the top bar, select your device that you connected before
2.5 Press *Play*
2.6 Possible errors:
    - The IOS Version on your device is too high/low, check the ios version specified in the Runner & Share Extension Targets
    - You have to trust the developer on your iphone first (*Settings > General > Device Management > select the profile to trust* )

## App Structure

- Every Screen has a dedicated file in the [screens](lib/screens) folder.
- Data that needs to be shared between screens is defined in the [article service file](lib/services/article_service.dart)
- All https calls are handled in the [server_handler file](lib/server_handler.dart)
- Data Models for the article and the audio file are defined in the [models](lib/models) folder
- The app menu, the page controller and the logic for receiving the shared data are implemented in the [main file](lib/main.dart)

## Resources for learning Flutter

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
