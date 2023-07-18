# Pietrocka Home
https://pietrockahome.web.app/

Pietrocka Home is a household management app built with Flutter that allows users to create and manage a shared list of chores and a shopping list, ensuring that all members of the household have access to the same information.

"Sorry, I forgot to buy bread" will no longer be said if you use Pietrocka Home!

## Features
- **Shared Chore List:** Create and manage a list of chores that can be accessed and updated by all members of the household.
- **Shared Shopping List:** Maintain a shared shopping list where users can add items that need to be purchased.
- **Filtering and Sorting:** Filter chores based on different criteria (e.g., assigned person, completion status) to easily find specific tasks. The app also allows sorting tasks based on a due date and importance to prioritize them effectively.
- **Multi-Language Support:** The app supports five languages, allowing users from different backgrounds to utilize the app in their preferred language.

## Code Architecture

Pietrocka Home follows a clean architecture pattern with a modified approach, package-based structure, and separation of concerns. The codebase is organized as follows:

- **Presentation Layer:** Contains the user interface components, screens, and UI-related logic. This is all written inside the lib folder.
- **Domain Layer:** Defines the core business logic and entities of the app, independent of any specific implementation.
- **Data Layer:** Handles data sources and data models for interacting with Firebase.
- **Common Layer:** Contains shared resources such as localization, themes, and utilities.
- **Dependency Injection:** Dependency injection is implemented using the `get_it` package, making it easy to manage and inject dependencies throughout the app.

!! Domain and data are split into different features in the form of packages to more effectively isolate them.

## Setup

To get started with Pietrocka Home, follow these steps:

1. Clone the repository
2. Ensure that you have Flutter and Dart installed on your machine.
3. Install the project dependencies by running `flutter pub get` in the project directory.
4. Set up Firebase backend then enable authentication and firestore.
6. Run flutter create . to create the android, iOS and web folders 
5. Configure Firebase for the project using the flutterfire cli
6. Build and run the app on your desired device

# Acknowledgements
I dedicate this app to my mother, because she inspired me to build it and is the most active user. Love you mom! :) 
