# Inventory Management App

Welcome to the Inventory Management App! This is a robust and intuitive mobile application built with Flutter, designed to help you effortlessly track your inventory, manage stock levels, and generate insightful reports. All data is stored locally on your device, ensuring privacy and offline accessibility.

## Features

- **Inventory Tracking:** Easily add, view, search, and delete items in your inventory.
- **Categorization:** Organize your items by creating custom categories (e.g., "Office Supplies," "Electronics").
- **Comprehensive Stock Management:**
    - **Receive Stock:** Log incoming items with quantity, date, and remarks.
    - **Issue Stock:** Track items issued to individuals or departments, including quantity and recipient details.
- **Data Persistence with Hive:** Your data is securely stored on your device using the fast and reliable Hive database.
- **Modern User Interface:**
    - A clean and intuitive UI built with Material Design principles.
    - A convenient Speed Dial Floating Action Button for quick access to primary actions: Add Item, Receive Stock, and Issue Stock.
    - An interactive **Welcome Guide** to help new users get started.
- **Financial Reporting:**
    - View detailed reports on stock receipts and issuances.
    - Filter reports by financial year for accurate bookkeeping.

## Getting Started

This project is built with Flutter. To get a local copy up and running, follow these simple steps.

### Prerequisites

Make sure you have the Flutter SDK installed on your machine. You can find installation instructions here: [Flutter Documentation](https://flutter.dev/docs/get-started/install)

### Installation & Running

1.  **Clone the repository:**
    ```sh
    git clone <YOUR_REPOSITORY_URL>
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd inventory-management-app
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```

## Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **Database:** Hive (local, NoSQL)
- **State Management:** Riverpod
- **Unique ID Generation:** UUID
- **UI Components:** Material Design
