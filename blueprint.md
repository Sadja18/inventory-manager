
# Inventory Management App Blueprint

## 1. Project Overview

This document outlines the architecture, features, and development plan for the Inventory Management mobile application. The app is built with Flutter and uses Hive for local database storage. It is designed to be a simple yet powerful tool for tracking inventory, managing stock levels, and generating reports.

## 2. Core Features & Style

### Implemented Features:
- **Inventory Tracking:** Add, view, search, and delete inventory items.
- **Categorization:** Group items into user-defined categories.
- **Stock Management:**
    - Record stock receipts with date and remarks.
    - Record stock issuances with recipient details and date.
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

## 3. Current Task: Fix `reports_screen.dart`

The immediate goal is to fix the critical errors in the reporting screen that are causing the application to crash.

### Plan:
1.  **Analyze Errors:** The root cause has been identified as a missing `quantity` field in the `IssuanceRecord` model and faulty fallback logic in the `reports_screen.dart` file.
2.  **Correct Data Model (Completed):**
    - The `quantity` field has been added to `lib/data/models/issuance_record_model.dart`.
    - The `build_runner` has been executed to update the Hive model adapter.
    - The `lib/presentation/screens/issue_item_screen.dart` has been updated to capture the quantity.
3.  **Fix `reports_screen.dart`:**
    - **Address `missing_required_argument` error:** Update the `orElse` clause in the `_buildReceiptsList` and `_buildIssuesList` widgets to provide a default `id` when creating a temporary `InventoryItem`.
    - **Confirm `undefined_getter` fix:** Ensure that the `quantity` field is now correctly accessed from `IssuanceRecord` objects for calculating totals and displaying in lists.

