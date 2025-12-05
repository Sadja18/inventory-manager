# Inventory Management App Blueprint

## 1. Project Overview

This document outlines the architecture, features, and development plan for the Inventory Management mobile application. The app is built with Flutter and uses Hive for local database storage. It is designed to be a simple yet powerful tool for tracking inventory, managing stock levels, and generating reports.

## 2. Core Features & Style

### Implemented Features:
- **Inventory Tracking:** Add, view, search, and delete inventory items.
- **Categorization:** Group items into user-defined categories.
- **Stock Management:**
    - Record stock receipts with date and remarks.
    - Record stock issuances with recipient details, date, and quantity.
- **Data Persistence:** All data is stored locally on the device using the Hive database.
- **User Interface:**
    - A clean, modern interface using Material Design components.
    - A floating action button with a speed dial for quick access to common actions (Add Item, Receive Stock, Issue Item).
    - A "Welcome Guide" for new users to help them get started.
- **Reporting:** A dedicated screen to view financial-year-based reports on stock receipts and issuances.

### Design & Style:
- **Theme:** A consistent theme with a primary color of deep purple.
- **Typography:** Uses standard Material Design typography.
- **Layout:** Responsive layouts that adapt to different screen sizes.

## 3. Current Task: Fix Welcome Guide Overflow

The `WelcomeGuide` widget is experiencing a vertical overflow on smaller screens after the fourth step was added. The goal is to fix this by making the content scrollable.

### Plan:
1.  **Read `welcome_guide.dart`**.
2.  **Wrap the `Column` widget with a `SingleChildScrollView`** to allow vertical scrolling when the content exceeds the screen height.
3.  **Write the corrected code back to the file.**
