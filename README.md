# 🗺️ Flutter OpenStreetMap App – Smooth & Pro

[![Flutter](https://img.shields.io/badge/Flutter-v3.22.0-blue?logo=flutter)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/State--Mgmt-GetX-blueviolet?logo=flutter)](https://pub.dev/packages/get)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A powerful and minimal **Flutter-based map application** using **OpenStreetMap**, built with smooth UI and pro-level UX – just like Google Maps. Lightweight, highly customizable, and perfect for apps needing embedded map support without relying on Google APIs.

---

## 🚀 Features

- 🔹 **OpenStreetMap integration** (no API key required)
- ⚡️ Smooth pan, zoom & drag gestures
- 📍 User location detection & marker
- 🧭 Add custom markers (tap / long-press)
- 🔄 MapController for full GetX state control
- 🗂️ MVVM + GetX architecture (View / Controller separation)
- 🧩 Easy to extend with route lines, polygons, layers, and more

---

## 📸 Preview

<img src="assets/screenshots/map_preview.png" width="600" alt="OpenStreetMap Flutter App UI" />

---

## 🧠 Tech Stack

- **Flutter** (Latest Stable)
- **Dart** – OOP, Clean Code, SOLID
- **[flutter_map](https://pub.dev/packages/flutter_map)** – OpenStreetMap rendering
- **[GetX](https://pub.dev/packages/get)** – State management & routing
- **LayerX Architecture** – By [Umair Hashmi](https://github.com/your-profile)

---

## 📦 Packages Used

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_map: ^6.0.0
  latlong2: ^0.9.0
  geolocator: ^11.0.0
  get: ^4.6.6
