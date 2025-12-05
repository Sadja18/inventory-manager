import 'package:hive/hive.dart';
import 'package:myapp/data/models/category_model.dart';
import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';

class Seeder {
  static Future<void> seedData() async {
    await _clearData();

    // Seed Categories
    final categoriesBox = await Hive.openBox<Category>('categories');
    final tech = Category(id: '1', name: 'Technology');
    final office = Category(id: '2', name: 'Office Supplies');
    final furniture = Category(id: '3', name: 'Furniture');
    await categoriesBox.addAll([tech, office, furniture]);

    // Seed Inventory Items
    final inventoryBox = await Hive.openBox<InventoryItem>('inventory_items');
    final items = [
      InventoryItem(id: '1', name: 'Laptop Dell XPS 15', categoryId: '1'),
      InventoryItem(id: '2', name: 'Logitech MX Master 3', categoryId: '1'),
      InventoryItem(id: '3', name: 'Herman Miller Aeron', categoryId: '3'),
      InventoryItem(id: '4', name: 'Pilot G2 Pens (Box)', categoryId: '2'),
      InventoryItem(id: '5', name: 'A4 Ream Paper', categoryId: '2'),
      InventoryItem(id: '6', name: 'Samsung 4K Monitor', categoryId: '1'),
      InventoryItem(id: '7', name: 'Apple MacBook Pro 16', categoryId: '1'),
      InventoryItem(id: '8', name: 'Steelcase Leap Chair', categoryId: '3'),
      InventoryItem(id: '9', name: 'Bose QC 35 Headphones', categoryId: '1'),
      InventoryItem(id: '10', name: 'Post-it Notes (12-pack)', categoryId: '2'),
      InventoryItem(id: '11', name: 'Electric Standing Desk', categoryId: '3'),
      InventoryItem(id: '12', name: 'Muji Notebook Set', categoryId: '2'),
      InventoryItem(id: '13', name: 'Anker USB-C Hub', categoryId: '1'),
      InventoryItem(id: '14', name: 'Swingline Stapler', categoryId: '2'),
      InventoryItem(id: '15', name: 'HP LaserJet Pro Printer', categoryId: '1'),
      InventoryItem(id: '16', name: 'IKEA Markus Chair', categoryId: '3'),
      InventoryItem(id: '17', name: 'Dell UltraSharp 27', categoryId: '1'),
      InventoryItem(
        id: '18',
        name: 'Sharpie Markers (Assorted)',
        categoryId: '2',
      ),
      InventoryItem(id: '19', name: 'Logitech K860 Keyboard', categoryId: '1'),
      InventoryItem(
        id: '20',
        name: 'AmazonBasics Monitor Stand',
        categoryId: '3',
      ),
    ];
    await inventoryBox.addAll(items);

    // Seed Stock Receipts & Issuances
    final stockReceiptBox = await Hive.openBox<StockReceipt>('stock_receipts');
    final issuanceBox = await Hive.openBox<IssuanceRecord>('issuance_records');

    // FY 2023-24 Data
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '1',
        quantity: 10,
        receiptDate: DateTime(2023, 5, 10),
      ),
    );
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '2',
        quantity: 25,
        receiptDate: DateTime(2023, 6, 15),
      ),
    );
    await issuanceBox.add(
      IssuanceRecord(
        id: 'iss1',
        itemId: '1',
        quantity: 2,
        issuanceDate: DateTime(2023, 7, 1),
        issuedTo: 'John Doe',
      ),
    );

    // FY 2024-25 Data
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '1',
        quantity: 5,
        receiptDate: DateTime(2024, 4, 20),
      ),
    );
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '4',
        quantity: 100,
        receiptDate: DateTime(2024, 5, 5),
      ),
    );
    await issuanceBox.add(
      IssuanceRecord(
        id: 'iss2',
        itemId: '1',
        quantity: 3,
        issuanceDate: DateTime(2024, 6, 12),
        issuedTo: 'Jane Smith',
      ),
    );
    await issuanceBox.add(
      IssuanceRecord(
        id: 'iss3',
        itemId: '2',
        quantity: 10,
        issuanceDate: DateTime(2024, 8, 22),
        issuedTo: 'Peter Jones',
      ),
    );
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '7',
        quantity: 15,
        receiptDate: DateTime(2024, 9, 1),
      ),
    );
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '8',
        quantity: 10,
        receiptDate: DateTime(2024, 9, 5),
      ),
    );
    await issuanceBox.add(
      IssuanceRecord(
        id: 'iss4',
        itemId: '7',
        quantity: 5,
        issuanceDate: DateTime(2024, 10, 15),
        issuedTo: 'John Doe',
      ),
    );
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '15',
        quantity: 8,
        receiptDate: DateTime(2024, 11, 20),
      ),
    );
    await stockReceiptBox.add(
      StockReceipt(
        itemId: '19',
        quantity: 30,
        receiptDate: DateTime(2025, 1, 18),
      ),
    );
    await issuanceBox.add(
      IssuanceRecord(
        id: 'iss5',
        itemId: '19',
        quantity: 10,
        issuanceDate: DateTime(2025, 2, 5),
        issuedTo: 'Jane Smith',
      ),
    );
  }

  static Future<void> _clearData() async {
    await Hive.deleteBoxFromDisk('categories');
    await Hive.deleteBoxFromDisk('inventory_items');
    await Hive.deleteBoxFromDisk('issuance_records');
    await Hive.deleteBoxFromDisk('stock_receipts');
  }
}
