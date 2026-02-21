# BrainMaps Explorer

BrainMaps Explorer is an iOS application that allows users to search and explore over 650,000 neuroscience fMRI studies from published research. The app connects to the NeuroVault API to provide access to real scientific data, including brain images, study metadata, participant demographics, and technical details.

## Features

- **Search Studies** - Search for neuroscience studies by cognitive paradigm, study type, or keywords
- **Featured Studies** - Browse 500 of the most recent studies added to the database
- **Study Details** - View comprehensive information about each study, including:
  - Brain activation images
  - Study type and methodology
  - Participant demographic data
  - Quantitative metrics with visual indicators
  - Technical specifications
- **Favorites System** - Save studies to a personal favorites collection
- **Infinite Scrolling** - Automatically loads more results as you scroll
- **Responsive UI** - Clean, intuitive interface that follows iOS design guidelines

## Requirements Met

This project was built for a CSCI 395 iOS Development course and fulfills the following requirements:

1. **REST API Call** - Uses URLSession to call the NeuroVault API with user-input parameters
2. **Extend Native Class** - Extends Notification.Name for custom notifications
3. **Multiple Screens** - Five unique view controllers with distinct functionality
4. **AutoLayout** - All interfaces built with AutoLayout constraints
5. **Dynamic TableView** - Table views that change based on API data
6. **Data Persistence** - Saves favorites to UserDefaults (plist)
7. **Delegate Protocol** - Implements UITextFieldDelegate and UITableViewDelegate patterns

## Technologies Used

- Swift 5
- UIKit
- URLSession
- AutoLayout
- UserDefaults
- MVC Architecture

## API Reference

This app uses the [NeuroVault API](https://neurovault.org/api-docs/). NeuroVault is a public repository of statistical maps, parcellations, and atlases of the human brain.

Key endpoints used:
- `GET /api/images` - Search and retrieve brain studies

## Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/BrainMaps-Explorer.git
```

2. Open the project in Xcode
```
cd BrainMaps-Explorer
open BrainMaps-Explorer.xcodeproj
```

4. Build and run the project

## Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Project Structure
```
BrainMaps-Explorer/
├── AppDelegate.swift           # App entry point and configuration
├── APIService.swift            # Network calls and data models
├── PersistenceManager.swift    # Favorites storage with UserDefaults
├── SearchViewController.swift  # Main search screen with featured studies
├── ResultsViewController.swift # Search results with infinite scrolling
├── StudyDetailViewController.swift # Detailed study information
├── FavoritesViewController.swift # Saved studies collection
└── WelcomeViewController.swift    # Animated welcome screen
```

## Acknowledgments
- [NeuroVault](https://neurovault.org) for providing access to their database of brain imaging studies
