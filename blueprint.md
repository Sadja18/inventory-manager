# Inventory Management App Blueprint

## 1. Project Overview

This document outlines the architecture, features, and development plan for the Inventory Management mobile application. The app is built with Flutter and uses Hive for local database storage. It is designed to be a simple yet powerful tool for tracking inventory, managing stock levels, and generating detailed reports.

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
- **Reporting:**
    - A dedicated reports screen to view a summary of all items.
    - A dropdown to filter the report by financial year.
    - A data table displays serial number, item name, total receipt quantity, total issued quantity, and final balance for the selected period.
- **Item History:**
    - Clicking on an item in the report navigates to a detailed history screen.
    - A tabbed view separates "Stock History" (receipts) and "Issuance History".
    - Each history tab displays a chronological list of transactions for the selected item and financial year.

### Design & Style:
- **Theme:** A consistent theme with a primary color of deep purple.
- **Typography:** Uses standard Material Design typography.
- **Layout:** Responsive layouts that adapt to different screen sizes.

## 3. Latest Implementation: Advanced Reporting

The latest update focused on building a comprehensive reporting module to provide insights into inventory movements.

### Plan & Execution:
1.  **Created a `reports_screen.dart`:** Built a new screen to house the reporting functionality.
2.  **Implemented Financial Year Logic:** Added a dropdown to allow users to select a financial year for the report.
3.  **Added Data Table:** Used the `data_table_2` package to create a sortable and paginated table to display item-wise summary data.
4.  **Developed `item_history_screen.dart`:** Created a new screen to show detailed transaction history for a single item.
5.  **Built `ReportGenerator` Class:** Encapsulated all data fetching and calculation logic in a dedicated `lib/data/report_generator.dart` file. This class queries the Hive database to:
    - Calculate opening balances.
    - Aggregate total receipts and issuances for a given financial year.
    - Determine the closing balance for each item.
    - Fetch detailed stock and issuance records for the history screen.
6.  **Integrated Real Data:** Replaced initial dummy data with live data fetched from Hive by integrating the `ReportGenerator` into the `ReportsScreen` and `ItemHistoryScreen`.
7.  **Enabled Navigation:** Implemented navigation from the main report table to the item history screen, passing the selected item's details.
