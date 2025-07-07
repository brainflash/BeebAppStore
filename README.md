# BeebAppStore
Technical test submission by Chris Scutt

A test iOS application built using **UIKit** that allows users to search for apps on the Apple App Store, view results in a list, and explore app details. The app supports **offline viewing**, **Core Data persistence**, and **VoiceOver accessibility**.

---

## Features
- 🔍 Search the iTunes App Store for iOS apps
- 🧠 Saves search terms and results using Core Data
- 💾 Offline access to past search results
- 🎯 Compatible with iOS 18+
- 🧪 Unit tests for the data structure and view data logic
- 👂 VoiceOver support

## Architecture
- **Architecture**: MVVM with Dependency Injection
- **Networking**: URLSession with a NetworkService abstraction, uses async/await
- **Persistence**: Uses Core Data with many-to-many relationship between SearchTerm and SearchResult

## Setup Instructions

1. Clone this repo:
   ```bash
   git clone https://github.com/brainflash/BeebAppStore.git

2. Open project in Xcode 16.4
   ```bash
     open BeebAppStore.xcodeproj
   
3. Build & Run the app on an iOS 18 simulator and/or device


## Project Structure
• Data/ - Data related classes including Core Data generated
• Services/ - Networking and API models + mapper
• Presentation/ - View controllers, storyboards, views and view models
• SearchTermManager.swift – Handles Core Data logic
• NetworkService.swift – Fetches iTunes data, maps to Core Data model
• NetworkMonitor.swift - monitors internet connection
• MainViewController.swift - initial view controller with search bar and results table
• DetailViewController.swift - detail view when a result is selected from the main view
• BeebAppStoreTests/ - XCUnit unit tests 
