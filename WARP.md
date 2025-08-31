# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview
Lambent is an iOS photography tutorial application that teaches photography fundamentals through interactive lessons. The app covers key concepts like aperture, shutter speed, ISO, focal length, and camera modes with hands-on demos and practice exercises.

## Technology Stack
- **Language**: Swift
- **Frameworks**: UIKit (primary), some SwiftUI elements
- **Dependency Management**: CocoaPods + Carthage
- **Database**: Firebase Realtime Database
- **Analytics**: Google Analytics
- **Reactive Programming**: RxSwift, RxSugar
- **Code Quality**: SwiftLint
- **Testing**: XCTest (Unit + UI tests)
- **Minimum iOS**: 10.3

## Development Commands

### Setup and Dependencies
```bash
# Install CocoaPods dependencies
pod install

# Update CocoaPods dependencies  
pod update

# Install/Update Carthage dependencies (from Photography directory)
cd Photography && carthage update --platform iOS

# Clean Carthage cache if needed
cd Photography && carthage clean
```

### Building and Running
```bash
# Build the project
xcodebuild -workspace Lambent.xcworkspace -scheme Lambent -configuration Debug build

# Build for release
xcodebuild -workspace Lambent.xcworkspace -scheme Lambent -configuration Release build

# Build and run on simulator
xcodebuild -workspace Lambent.xcworkspace -scheme Lambent -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 14' build

# Open in Xcode
open Lambent.xcworkspace
```

### Testing
```bash
# Run unit tests
xcodebuild test -workspace Lambent.xcworkspace -scheme Lambent -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:PhotographyTests

# Run UI tests
xcodebuild test -workspace Lambent.xcworkspace -scheme Lambent -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:LambentUITests

# Run all tests
xcodebuild test -workspace Lambent.xcworkspace -scheme Lambent -destination 'platform=iOS Simulator,name=iPhone 14'

# Run specific test class
xcodebuild test -workspace Lambent.xcworkspace -scheme Lambent -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:PhotographyTests/TutorialTests

# Run single test method
xcodebuild test -workspace Lambent.xcworkspace -scheme Lambent -destination 'platform=iOS Simulator,name=iPhone 14' -only-testing:PhotographyTests/TutorialTests/testDemoRegisteredWhenDemo
```

### Code Quality
```bash
# Run SwiftLint
swiftlint

# Auto-fix SwiftLint issues where possible
swiftlint --fix

# Run SwiftLint on specific files
swiftlint lint Photography/ContentView.swift

# SwiftLint with strict mode (treats warnings as errors)
swiftlint --strict
```

## Architecture Overview

### App Structure
- **AppDelegate**: Firebase configuration, Google Analytics setup, app lifecycle management
- **HomeViewController/HomeView**: Main menu displaying photography sections (Overview, Aperture, Shutter Speed, ISO, Focal Length, Modes)
- **ContentView**: Container for tutorial content with segmented control for Intro/Demo/Practice modes
- **TutorialModel**: Business logic for tutorial content and navigation
- **ServiceLayer**: Firebase data fetching and content management
- **PhotographyModel**: Main reactive data model using RxSwift

### Key Components
- **DemoView**: Interactive sliders and image demonstrations for photography concepts
- **PracticeView**: Hands-on exercises for users to practice concepts
- **HomeCell**: Custom table view cells for the main menu
- **CameraHandler**: Camera functionality integration
- **Cache**: Image and content caching system

### Data Flow
1. **ServiceLayer** fetches content from Firebase
2. **PhotographyModel** processes and exposes data via RxSwift observables  
3. **HomeView** displays menu items from content sections
4. **ContentView** renders tutorial content based on selected page and segment
5. **TutorialModel** manages tutorial state and navigation logic

### Navigation Structure
```
Home (6 sections) → Tutorial Pages (Overview, Aperture, Shutter, ISO, Focal, Modes)
                 → Segments (Intro/Demo/Practice or mode-specific for Modes page)
```

### Firebase Integration
- Uses Firebase Realtime Database for tutorial content storage
- Content structure: sections, descriptions, introductions, exercises, instructions
- Supports offline persistence via `isPersistenceEnabled = true`

### Testing Strategy
- **Unit Tests** (`PhotographyTests/`): Test tutorial logic, content configuration, navigation
- **UI Tests** (`LambentUITests/`): Test navigation flow, demo interactions, content display
- Tests cover page navigation, segmented control behavior, and demo slider interactions

## Key Files to Understand
- `Photography/AppDelegate.swift`: App initialization and configuration
- `Photography/ContentView.swift`: Main tutorial interface with segmented controls
- `Photography/PhotographyModel.swift`: Core reactive data model
- `Photography/ServiceLayer.swift`: Firebase data layer
- `Photography/TutorialModel.swift`: Tutorial business logic (check TutorialView.swift in root)
- `Photography/HomeView.swift`: Main menu interface
- `Podfile`: CocoaPods dependencies
- `Photography/Cartfile`: Carthage dependencies for RxSwift
- `.swiftlint.yml`: SwiftLint configuration with disabled rules for line length, whitespace, etc.

## Important Notes
- Always use `Lambent.xcworkspace`, not the `.xcodeproj` file, due to CocoaPods integration
- The app uses both CocoaPods and Carthage - ensure both dependency managers are properly set up
- Firebase configuration file `GoogleService-Info.plist` is required for database functionality
- SwiftLint configuration disables several rules (line_length, trailing_whitespace, colon, function_body_length, etc.)
- The main source code is in the `Photography/` directory, with some Swift files in the root
