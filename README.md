# 🖼️ Flutter Wallpaper App

A beautifully designed Flutter application for browsing, downloading, and setting wallpapers. This app integrates the Pexels API for an extensive collection of high-quality wallpapers. Users can download wallpapers directly to their device, and set them as wallpaper through the app using the Storage Access Framework (SAF).

## 📱 Features

- **Wallpaper Browsing**

  - Explore thousands of high-quality wallpapers from Pexels, including categories like nature, abstract, animals, and more.
  - Seamless search functionality to find wallpapers that fit your taste.

- **Wallpaper Details**

  - View details of selected wallpapers, including photographer credits, resolution, and color scheme.

- **Download and Set as Wallpaper**

  - Download wallpapers directly to your device with the **Storage Access Framework (SAF)**.
  - Instantly set the wallpaper directly from the app for a quick and personalized experience.

- **Favorites**

  - Save wallpapers to your favorites for easy access and browsing later.

- **State Management**
  - Efficient state management using the [Provider](https://pub.dev/packages/provider) package, ensuring a smooth and responsive UI.

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- An IDE like [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/bijithpn/wallpaper-app.git
   cd wallpaper-app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Set up API key**

   - Sign up at [Pexels](https://www.pexels.com/) and obtain your API key.
   - Insert your API key in the appropriate file, typically in the API service or `.env` file.

4. **Run the app:**
   ```bash
   flutter run
   ```

## 📦 Dependencies

- **State Management**: [provider](https://pub.dev/packages/provider) - for managing app-wide state.
- **Networking**: [DIO](https://pub.dev/packages/dio) - for API calls.
- **Storage**: [saf](https://pub.dev/packages/saf) - to enable downloading and setting wallpapers.
- **Wallpaper Setting**: Custom integration to support setting wallpapers through app features.

## 🗂️ Project Structure

```plaintext
lib/
├── api_conifg/            # api config and api client  for wallpaper data
├── providers/             # State management providers for wallpaper data
├── data/                  # Data models and API services
│   ├── models/            # Models for wallpapers and categories
│   └── repositories/      # Repositories for API calls and data fetching
├── screens/               # Screens for browsing, details, and favorites
├── widgets/               # Reusable components for UI
├── db/                    # model class and db setup for hive
├── utils/                 # utils funtions
└── main.dart              # Entry point of the application
```

## 📡 API Integration

- **Pexels API:**  
  This app uses the [Pexels API](https://www.pexels.com/api/) to fetch high-quality images and wallpapers. The API provides endpoints to search and browse image collections.

  - Base URL: `https://api.pexels.com/v1/`
  - Required headers: `Authorization: YOUR_API_KEY`

- _More API integration details will be added here._

## 📸 Screenshots

<img src="https://github.com/bijithpn/wallpaper-app/blob/main/screenshots/1.gif?raw=true" alt="App img" width="300"/>

## 🔧 Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature-name`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature-name`).
5. Create a new Pull Request.

## 📜 License

This project is licensed under the MIT License.

---
