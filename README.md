
## Strands



A Flutter-based thread-clone application where users can create posts, comment, like, follow/unfollow others, and add a bio. Authentication and backend services are powered by Firebase Auth.



## Table of Contents

- Demo
- Features
- Installation
- Usage
- Firebase Setup
- Technologies Used
Contributing
License

**Demo**



Watch the demo video



**Features**

- **Create Post**: Compose and publish text-based posts.
- **Comment**: Reply to any post with threaded comments.
- **Like**: Like or unlike posts and comments.
- **Follow / Unfollow**: Follow other users to see their posts in your feed.
- **Bio**: Edit and display a short user biography on profiles.

**Installation**

Prerequisites

- Flutter SDK (>=2.5.0)
- Dart SDK
- A Firebase project with Auth enabled

Steps

**Clone the repository**
**Install dependencies**
**Configure Firebase** (See Firebase Setup)
**Run the app**

**Usage**

- On first launch, sign up or log in with your email/password.
- Tap the + button to create a new post.
- Tap the comment icon under any post to view or add comments.
- Tap the heart icon to like or unlike a post.
- Visit a user’s profile to follow/unfollow or edit your bio.

**Firebase Setup**

Go to the Firebase Console and create a new project.
Enable **Authentication > Email/Password**.
Add an Android and/or iOS app in **Project Settings** and download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS).
Place the config file in the respective platform directory:

Android: `android/app/google-services.json`
iOS: `ios/Runner/GoogleService-Info.plist`
Install FlutterFire CLI and configure:

**Technologies Used**

- **Flutter** - UI toolkit for building natively compiled apps
- **Provider** - State management
- **Firebase Auth** - User authentication
- **Firebase Firestore** - Real-time database

**Contributing**

Contributions are welcome! Please open an issue or submit a pull request with improvements.

```
dart pub global activate flutterfire_cli
flutterfire configure
```

```
flutter run
```

```
flutter pub get
```

```
git clone https://github.com/your-username/strands.git
cd strands
```
