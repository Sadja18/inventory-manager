import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:myapp/data/models/category_model.dart';
import 'package:myapp/data/models/inventory_item_model.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';
import 'package:myapp/data/seeder.dart';
import 'package:myapp/di/theme_provider.dart';
import 'package:myapp/navigation_routes.dart';
import 'package:myapp/presentation/screens/add_item_screen.dart';
import 'package:myapp/presentation/screens/category_screen.dart';
import 'package:myapp/presentation/screens/inventory_screen.dart';
import 'package:myapp/presentation/screens/issue_item_screen.dart';
import 'package:myapp/presentation/screens/item_history_screen.dart';
import 'package:myapp/presentation/screens/receive_stock_screen.dart';
import 'package:myapp/presentation/screens/reports_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(InventoryItemAdapter());
  Hive.registerAdapter(IssuanceRecordAdapter());
  Hive.registerAdapter(StockReceiptAdapter());

  // TODO: Remove this line before production. This is for testing only.
  await Seeder.seedData();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(
        fontSize: 57,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.oswald(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    return MaterialApp(
      title: 'Office Inventory Tracker',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const MyHomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.addItem:
            return MaterialPageRoute(builder: (_) => const AddItemScreen());
          case AppRoutes.issueItem:
            return MaterialPageRoute(builder: (_) => const IssueItemScreen());
          case AppRoutes.itemHistory:
            final args = settings.arguments as Map<String, dynamic>;
            final itemId = args['itemId'] as String;
            final itemName = args['itemName'] as String;
            final financialYear = args['financialYear'] as String;
            return MaterialPageRoute(
              builder: (_) => ItemHistoryScreen(
                itemId: itemId,
                itemName: itemName,
                financialYear: financialYear,
              ),
            );
          case AppRoutes.receiveStock:
            return MaterialPageRoute(
              builder: (_) => const ReceiveStockScreen(),
            );
          default:
            return MaterialPageRoute(builder: (_) => const MyHomePage());
        }
      },
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    InventoryScreen(),
    CategoryScreen(),
    ReportsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Tracker'),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withAlpha(179),
        onTap: _onItemTapped,
      ),
    );
  }
}
