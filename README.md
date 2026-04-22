# TalkSpace Project Documentation

## 1. Project Overview
**TalkSpace** is a modern, real-time iOS chat application built entirely using **SwiftUI**. It allows users to register, log in, manage their profiles, discover other users, and engage in real-time text and image-based conversations. 

The application utilizes **Firebase** as its complete backend-as-a-service (BaaS) provider, handling authentication, real-time database updates, and media storage.

## 2. Tech Stack
* **Language:** Swift 5+
* **UI Framework:** SwiftUI
* **Architecture Pattern:** MVVM (Model-View-ViewModel) + Service Layer
* **Backend Services (Firebase):**
  * **Firebase Authentication:** For user sign-up, login, and session management.
  * **Cloud Firestore:** A NoSQL real-time database used to store user profiles, individual chat messages, and recent conversation histories.
  * **Firebase Cloud Storage:** Used to store and serve media files like user profile pictures and images sent within chats.

## 3. Project Structure
The project is organized in a feature-driven, modular structure to ensure maintainability and separation of concerns.

```text
TalkSpace/
├── App/
│   └── TalkSpaceApp.swift        # Application entry point & root routing logic
├── Core/
│   ├── Utils/
│   │   ├── Firebase/             # Firebase Manager Singletons
│   │   │   ├── AuthManager.swift
│   │   │   ├── ChatManager.swift
│   │   │   ├── StorageManager.swift
│   │   │   └── UserManager.swift
│   │   └── KeyboardUtils.swift
│   └── Constants/, Extensions/
├── Features/
│   ├── Authentication/           # Login & Registration views, models, viewmodels
│   ├── Chat/                     # Chat interface, message rows, ChatService
│   ├── Home/                     # Recent contacts, Home screen views
│   └── Profile/                  # User profile configuration and display
└── Resources/
```

## 4. How It Works (Implementation Details)

### Application Initialization & Routing
The app starts at `TalkSpaceApp.swift`. It sets up an `AppDelegate` to initialize Firebase via `FirebaseApp.configure()`. The root view checks the `FirebaseAuth` state: if a `currentUser` exists, it routes the user to `HomeView`; otherwise, it directs them to `LoginView`.

### Core Firebase Managers
The `Core/Utils/Firebase` directory contains dedicated singleton managers that wrap Firebase SDK calls, abstracting the database layer away from the UI and ViewModels:

1. **`AuthManager`**: Manages communication with Firebase Authentication for logging in, signing up, and signing out.
2. **`UserManager`**: Interacts with the `users` Firestore collection. It handles fetching user profiles, updating display names, saving user data upon registration, and fetching the list of all registered users.
3. **`StorageManager`**: Handles uploading image data (JPEGs) to Firebase Cloud Storage. It separates logic for `profileImages` and `chat_images`, returning absolute download URLs after successful uploads.
4. **`ChatManager`**: Manages the core messaging database logic.
   - **`messages` collection**: Stores complete chat histories. Messages are stored bi-directionally (under both sender and receiver documents) to allow independent deletion and querying.
   - **`recent_messages` collection**: Maintains the latest message for every active conversation to populate the `HomeView` inbox efficiently without querying the entire message history.

### Feature Services (e.g., `ChatService`)
To orchestrate complex operations spanning multiple managers, the app uses Feature Services. For example, `ChatService` conforms to `ChatServicable` and depends on `UserManager`, `ChatManager`, and `StorageManager`. 

When a user sends an image message:
1. `ChatService` calls `StorageManager` to upload the image.
2. It receives the image URL and constructs a message dictionary.
3. It calls `ChatManager` to save the message to the Firestore `messages` collection.
4. It updates the `recent_messages` collection so the Home screen reflects the newly sent image.

### Real-time Updates
The app leverages Firestore's `addSnapshotListener`. 
- In the Chat interface, a listener is attached to the specific conversation thread. Any new document added (either by the current user or the remote user) instantly triggers a closure that decodes the payload into Swift `Message` models, which the ViewModel publishes to the SwiftUI View.
- Similarly, the Home screen listens to the `recent_messages` collection to instantly re-order or update the inbox preview when new messages arrive.

## 5. Security & Data Isolation
The data in Firestore is structured to separate individual chat data (`messages` -> `senderId` -> `receiverId`) and recent chat previews (`recent_messages` -> `userId` -> `messages`). This nested sub-collection approach ensures that fetching a user's inbox only requires reading their specific `recent_messages` document space, optimizing reads and allowing for straightforward Firebase Security Rule enforcement.
