# Office Inventory Tracker (Flutter MVP)

A **local-first**, paper-complementary mobile app to digitize office supply tracking — designed for organizations that rely on physical sign-off forms but want faster search, reporting, and audit preparation.

> ✨ **Goal**: Accelerate inventory management **without replacing** trusted paper trails.  
> 📱 **Platform**: Android & iOS (Flutter)  
> 🗃️ **Storage**: Local device only (no backend, no internet required)

---

## 🚀 Problem It Solves

Many offices still use **paper-based systems** for issuing items like pens, extension cords, or LAN cables:
- Staff manually log receipts/issuances on paper
- Excel is later updated for reports
- Audits require compiling physical forms → **time-consuming & error-prone**

This app **complements** that workflow:
- Import initial inventory from Excel
- Record digital copies of issuances (with recipient & remarks)
- Instantly search items or view low-stock alerts
- Export clean reports for auditors
- **Paper remains the legal proof** — the app is a **searchable digital twin**

---

## 📱 Key Features (MVP)

- ✅ **Import inventory** from Excel (`.xlsx`)  
- ✅ **Add new items** not in original Excel  
- ✅ **Issue items** with recipient, quantity, date, and remarks  
- ✅ **Categorize items** (Stationery, Electrical – Office, Equipment, etc.) + add custom categories  
- ✅ **View full history** per item: when receipts/issuances happened  
- ✅ **Low-stock alerts** (configurable threshold)  
- ✅ **Export reports** as Excel/CSV:
  - Inventory Summary (`Item, Category, Receipt, Issued, Balance`)
  - Issuance Log (`Date, Item, Qty, Recipient, Remarks`)
- ✅ **100% offline** — no cloud, no login, no internet needed

---

## 🧱 Architecture Overview

### Tech Stack
| Layer | Technology |
|------|-----------|
| Framework | Flutter (Dart) |
| State Mgmt | Riverpod |
| Local DB | Hive (NoSQL, embedded) |
| Excel I/O | `excel` + `csv` packages |
| Navigation | Named routes (`Navigator.pushNamed`) |

### Directory Structure
```
lib/
├── core/               # Utils, constants
├── data/               # Hive models & repositories
├── presentation/       # Screens, widgets, viewmodels
├── di/                 # Riverpod providers
├── navigation_routes.dart
└── main.dart
```

### Data Models (Hive)
1. **`Category`** – reusable categories (e.g., "Stationery")
2. **`Item`** – inventory item with receipt/issued/balance
3. **`Issuance`** – transaction log for each issue event

> 🔒 **No user model** – single-device use assumed.

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (3.19+)
- Dart SDK (3.3+)
- [Hive Type Adapter Generator](https://docs.hivedb.dev/#/)

### Installation
1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/office-inventory-tracker.git
   cd office-inventory-tracker
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Hive adapters:
   ```bash
   flutter packages pub run build_runner build
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 🧪 Usage Workflow

1. **On first launch**: Import your existing inventory Excel file  
   (Template: columns = `Item Name, Category, Receipt Qty, Remarks`)
2. **Issue an item**: 
   - Go to *Inventory* → tap item → *Issue*
   - Fill: quantity, recipient (optional), remarks, date
   - **Still sign paper form** — this app is digital backup
3. **Add new item**: Use “+ New Item” if something wasn’t in Excel
4. **Audit prep**: Go to *Reports* → export Inventory or Issuance Log

---

## 📂 Project Structure Highlights

| File/Dir | Purpose |
|--------|--------|
| `navigation_routes.dart` | Centralized route names (e.g., `/inventory`) |
| `data/models/` | Hive data classes (`item.dart`, `category.dart`, etc.) |
| `data/repositories/` | Local DB logic (e.g., `ItemRepository.updateBalance()`) |
| `presentation/viewmodels/` | Riverpod ViewModels (business logic) |
| `di/providers.dart` | All Riverpod providers (repos + viewmodels) |
| `core/utils/excel_exporter.dart` | Converts data → Excel/CSV |

---

## 🤝 Contributing

This is a personal MVP, but contributions are welcome!
1. Fork the repo
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

> 💡 **Focus areas**:  
> - Excel import robustness  
> - Backup/restore (export full DB)  
> - Dark mode (UI polish)

---

## 📄 License

MIT License – see [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgements

- Built with ❤️ for office admins tired of paper pile audits
- Uses [Hive](https://hive.dev) for blazing-fast local storage
- Inspired by real-world friction in inventory tracking

---

> ✨ **Remember**: This app **does not replace paper signatures** — it just makes finding them *much faster*.