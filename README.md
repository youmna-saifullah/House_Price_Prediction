# 🏠 House Price Prediction App

A Flutter mobile application that predicts house prices using machine learning, with a Python Flask backend.



## Features

- **AI-Powered Predictions**: Machine learning model trained on housing data
- **Cross-Platform**: Works on both Android and iOS
- **User-Friendly Interface**: Simple form input with clear results
- **Backend API**: Flask server handles model predictions
- **Responsive Design**: Adapts to different screen sizes

## 📦 Prerequisites

- Flutter SDK (v3.0.0 or higher)
- Python 3.8+
- Android Studio/Xcode (for emulators)
- Pip package manager

## 🛠️ Installation

### Backend Setup

1. Navigate to backend folder:
   ```bash
   cd Backend
2.
pip install -r requirements.txt
python model.py
python app.py

### Frontend Setup
cd house_price_prediction
flutter pub get
flutter run

house_price_prediction/
├── Backend/               # Python Flask API
│   ├── app.py             # Flask server
│   ├── model.py           # ML model training
│   └── requirements.txt   # Python dependencies
│
├── assets/                # App assets
│   └── house_bg.png       # Background image
│
├── lib/                   # Flutter source code
│   ├── main.dart          # App entry point
│   ├── home_page.dart     # Main screen UI
│   └── prediction_page.dart # Prediction form
│
└── pubspec.yaml           # Flutter dependencies

