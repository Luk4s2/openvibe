# 🧠 Flutter example of message chat

A cleanly architected **Flutter** social media-style app that displays a feed of user messages using a **WebSocket** connection to fetch data in real-time.

## 📱 Features

- 🔄 Real-time message fetching from a WebSocket server
- 🧑‍💻 Message list UI with:
  - Emoji avatar
  - Nickname
  - Message preview
  - Twitter-style relative timestamp
- 📄 Detailed message screen with:
  - Full timestamp
  - Full message
  - Consistent design
- 🔁 Hot reload support
- 🧠 Clean Architecture + Dependency Injection

---

## 🧱 Architecture

Follows **Clean Architecture** principles:

```
lib/
├── core/
│   ├── constants/
│   ├── di/                   # Dependency injection setup
│   └── utils/                # Formatters, helpers
│
├── features/
│   └── messages/
│       ├── data/             # WebSocket + repository
│       ├── domain/           # Entities + UseCases
│       └── presentation/     # Bloc + Screens
```

- 💡 `domain`: business logic & abstractions
- 🛰️ `data`: WebSocket implementation
- 🎨 `presentation`: UI and state management

---

## 🚀 Getting Started

### ✅ Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart Frog CLI for mock backend

```bash
dart pub global activate dart_frog_cli
```

### 🛠️ Installation

1. Clone the repo:
```bash
git clone https://github.com/luk4s2/openvibe
```

2. Get dependencies:
```bash
flutter pub get
```

3. Start the mock server:
```bash
cd server
dart_frog dev
```

4. Run the app:
```bash
flutter run
```

---

## 🧪 Testing

Unit testing can be added to:
- `usecases/`
- `bloc/`

Add test dependencies in `pubspec.yaml` and use:

```bash
flutter test
```

---

## 🔗 Technologies

- [Flutter](https://flutter.dev/)
- [Bloc](https://pub.dev/packages/flutter_bloc)
- [GetIt](https://pub.dev/packages/get_it)
- [WebSocket Channel](https://pub.dev/packages/web_socket_channel)
- [Dart Frog](https://dartfrog.vgv.dev/)

---

## 📄 License

This project is for educational/demo purposes and not licensed for production use.
