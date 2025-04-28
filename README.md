# CryptoBit

**Slogan:** Feel the market’s heartbeat

---

## Table of Contents

1. [Overview](#overview)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Requirements & Environment](#requirements--environment)
5. [Installation & Running](#installation--running)
6. [Architecture](#architecture)
7. [Project Structure](#project-structure)
8. [Assumptions & Decisions](#assumptions--decisions)
9. [Challenges & Solutions](#challenges--solutions)
10. [Testing](#testing)
11. [Screenshots & Videos](#screenshots--videos)
12. [License](#license)

---

## Overview

CryptoBit is an iOS application that fetches and displays the top 100 cryptocurrency coins using the CoinRanking API. It supports pagination, filtering, favorites, and detailed performance charts—providing users a seamless way to track market movements.

---

## Features

- **Top 100 Coins List** (paginated 20 at a time)
  - Icon, Name, Current Price, 24h Change
  - Filter by price or 24h performance
  - Swipe to favorite/unfavorite
- **Coin Detail**
  - Name, Price, 24h Change
  - Interactive performance chart with time-window filters (1D, 1W, 1M)
  - Additional stats (market cap, volume, rank)
- **Favorites**
  - Persistent list of favorited coins
  - Swipe to remove from favorites
- **Animated SwiftUI Splash Screen**

---

## Tech Stack

- **Language:** Swift 5
- **UI:** UIKit (lists) + SwiftUI (charts, pickers, splash)
- **Networking:** URLSession + Combine (via `APIGateway`)
- **Persistence:** Core Data for favorites
- **Charts:** [Charts](https://github.com/danielgindi/Charts)
- **Image Loading:** AlamofireImage for asynchronous icon fetching
- **Loading Indicators:** Skeleton Loader (e.g. [SkeletonView](https://github.com/Juanpe/SkeletonView)) for placeholder animations
- **Unit/UI Testing:** XCTest, Combine test stubs, in-memory Core Data

---

## Requirements & Environment

- **macOS:** Ventura or later (tested on MacBook Pro M2)
- **Xcode:** 16.2
- **iOS Deployment Target:** 14.0+
- **Test Device:** iPhone 15 Pro Max (iOS 18.3)

---

## Installation & Running

1. **Clone the repo**
   ```bash
   git clone https://github.com/yourusername/cryptobit.git
   cd cryptobit
   ```
2. **Install dependencies**
   - Swift Package Manager will auto-resolve any packages on first build.
3. **Open the Project**
   - Double-click `CryptoBit.xcodeproj` to launch Xcode.
4. **Set Up Signing & Capabilities**
   - In the Xcode Project Navigator, select the **CryptoBit** target.
   - Go to the **Signing & Capabilities** tab.
   - Update **Bundle Identifier** (e.g. `com.yourcompany.cryptobit`).
   - Select your **Team** or **Add Account...** if needed.
   - Allow Xcode to **Manage signing** automatically.
5. **Build & Run**
   - Choose the **CryptoBit** scheme and your device or simulator.
   - Press **⌘B** to build, then **⌘R** to run.

---

## Architecture

CryptoBit follows a **MVVM** architecture:

- **Model:** Codable structs (`Coin`, `CoinDetail`, `Stats`) representing API data.
- **ViewModel:** `ObservableObject` classes with `@Published` for state, pagination, and filtering.
- **View (UIKit):** `UIViewController` subclasses with `UITableView`/`UICollectionView` for list and detail screens.
- **View (SwiftUI):** Charts, filter pickers, and splash embedded via `UIHostingController`.
- **Service Layer:** `APIGateway` for HTTP, and `CoinAPIClient` for endpoint logic.
- **Persistence:** `CoreDataManager` with `NSPersistentContainer`, injected for in-memory testing.

---

## Project Structure

```
CryptoBit/
├─ App/
├─ Business/
│  ├─ APIGateway/
│  ├─ DB/
│  ├─ Models/
│  ├─ Services/
│  └─ CustomViews/
├─ Data/
├─ PresentationModule/
│  ├─ AuthModule/
│  ├─ CoinListModule/
│  ├─ DetailedCoinModule/
│  ├─ FavoriteCoinModule/
│  ├─ HardWallModule/
│  └─ SplashScreen/
└─ Tests/
```

---

## Assumptions & Decisions

- Supporting **iOS 14+** to leverage SwiftUI integration.
- Using **Core Data** for favorites persistence.
- Employing **Combine** for reactive state management.
- Hybrid UI: performance-critical lists in UIKit, micro-views in SwiftUI.

---

## Challenges & Solutions

- **Pagination & Filtering:** Offset-based Combine loading patterns.
- **Nested JSON Structure:** Generic `APIGateway` to unify requests, headers, decoding.
- **Animated Splash:** SwiftUI `SplashView` with scale and opacity animations.
- **Icon URL Formats:** Replaced unsupported `.svg` URLs with `.png` variants.
- **In-Memory Testing:** Injected `NSPersistentContainer` for fast Core Data tests.

---

## Testing

- **Unit Tests:** Model decoding, ViewModel logic, Core Data favorites.
- **UI Tests:** List, favorite, unfavorite flows via XCTest & XCUITest.
- **Run Tests:** Press **⌘U** or use **Product → Test** in Xcode.

---

## Screenshots & Videos

### Screenshots

![Coins List](docs/screenshots/coins_list.png)
![Coin Detail](docs/screenshots/coin_detail.png)
![Favorites](docs/screenshots/favorites.png)

### Demo Video

[Watch on YouTube](https://youtu.be/your-demo-link)

---

## License

MIT © 2025 Your Name
