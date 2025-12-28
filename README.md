# 🎬 MovieXI - Flutter Movie App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![TMDb](https://img.shields.io/badge/TMDb-API-90CEA1?style=for-the-badge&logo=themoviedatabase&logoColor=black)

**MovieXI** is a robust mobile application designed for movie enthusiasts. Built with **Flutter**, it leverages **The Movie Database (TMDb) API** for real-time data and **Firebase** for a seamless backend experience, allowing users to discover movies, manage favorites, and curate their personal watchlists.

This project demonstrates the implementation of Clean Architecture, State Management using Provider, and complex Backend integration.

---

## ✨ Key Features

* **🔐 Authentication:** Secure Login and Registration using Firebase Auth (Email/Password).
* **🏠 Dynamic Home:** Showcases Now Playing, Trending, and Popular movies.
* **🔍 Smart Search:** Real-time movie search with debounce functionality.
* **📄 Detailed Insights:** View comprehensive movie details including synopsis, ratings, and release info.
* **❤️ Favorites & Watchlist:** Save movies to your personal library (stored in Cloud Firestore).
* **👤 Profile Management:** User profile overview and logout functionality.
* **🎨 Responsive UI:** Beautiful Dark Mode interface with cached images for performance.

---

## 📱 Screenshots

| Home Screen | Search & Grid | Movie Detail |
|:---:|:---:|:---:|
| <img src="screenshots/home.png" width="200"/> | <img src="screenshots/search.png" width="200"/> | <img src="screenshots/detail.png" width="200"/> |

| Favorites | Watchlist | Profile |
|:---:|:---:|:---:|
| <img src="screenshots/favorite.png" width="200"/> | <img src="screenshots/watchlist.png" width="200"/> | <img src="screenshots/profile.png" width="200"/> |

> *Note: Screenshots are placeholders. Please add your own images to a `screenshots` folder.*

---

## 🛠 Tech Stack & Architecture

* **Framework:** Flutter (Dart)
* **State Management:** Provider
* **Backend:** Firebase Authentication, Cloud Firestore
* **API:** TMDb (The Movie Database) API
* **Networking:** http package
* **UI Components:** Cached Network Image, Google Fonts

**Folder Structure:**
```text
lib/
├── models/        # Data models (JSON parsing)
├── providers/     # State management logic
├── services/      # API & Firebase services
├── ui/            # Screens & Widgets
└── utils/         # Constants & Helpers
