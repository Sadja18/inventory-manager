import 'dart:io';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/issuance_record_model.dart';
import 'package:myapp/data/models/stock_receipt_model.dart';
import 'package:myapp/data/report_generator.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ItemHistoryScreen extends ConsumerStatefulWidget {
  final String itemId;
  final String itemName;
  final String financialYear;

  const ItemHistoryScreen({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.financialYear,
  });

  @override
  ConsumerState<ItemHistoryScreen> createState() => _ItemHistoryScreenState();
}

class _ItemHistoryScreenState extends ConsumerState<ItemHistoryScreen>
    with SingleTickerProviderStateMixin {
  final ReportGenerator _reportGenerator = ReportGenerator();
  late Future<List<StockReceipt>> _stockHistoryFuture;
  late Future<List<IssuanceRecord>> _issuanceHistoryFuture;

  late TabController _tabController;

  int _stockCurrentPage = 0;
  int _issuanceCurrentPage = 0;
  static const int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistoryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadHistoryData() {
    setState(() {
      _stockHistoryFuture = _reportGenerator.getItemStockHistory(
        widget.itemId,
        widget.financialYear,
      );
      _issuanceHistoryFuture = _reportGenerator.getItemIssuanceHistory(
        widget.itemId,
        widget.financialYear,
      );
    });
  }

  Future<void> _exportStockHistory(List<StockReceipt> fullData) async {
    if (fullData.isEmpty) {
      _showSnackbar('No stock history to export.');
      return;
    }

    final excelFile = excel.Excel.createExcel();
    final sheet = excelFile['Sheet1'];

    sheet.appendRow([
      excel.TextCellValue('Date'),
      excel.TextCellValue('Quantity Received'),
      excel.TextCellValue('Remarks'),
    ]);

    for (final receipt in fullData) {
      sheet.appendRow([
        excel.TextCellValue(
          DateFormat('yyyy-MM-dd').format(receipt.receiptDate),
        ),
        excel.IntCellValue(receipt.quantity),
        excel.TextCellValue(receipt.remarks ?? ''),
      ]);
    }

    await _saveAndOpenExcel(
      excelFile,
      'stock_history_${widget.itemName.replaceAll(RegExp(r'[^\w]'), '_')}_${widget.financialYear.replaceAll(' ', '_')}',
    );
  }

  Future<void> _exportIssuanceHistory(List<IssuanceRecord> fullData) async {
    if (fullData.isEmpty) {
      _showSnackbar('No issuance history to export.');
      return;
    }

    final excelFile = excel.Excel.createExcel();
    final sheet = excelFile['Sheet1'];

    // sheet.appendRow([
    //   excel.TextCellValue('Date'),
    //   excel.TextCellValue('Issued To'),
    //   excel.TextCellValue('Quantity Issued'),
    // ]);

    // for (final issuance in fullData) {
    //   sheet.appendRow([
    //     excel.TextCellValue(
    //       DateFormat('yyyy-MM-dd').format(issuance.issuanceDate),
    //     ),
    //     excel.TextCellValue(issuance.issuedTo),
    //     excel.IntCellValue(issuance.quantity),
    //   ]);
    // }
    sheet.appendRow([
      excel.TextCellValue('Date'),
      excel.TextCellValue('Issued To'),
      excel.TextCellValue('Quantity Issued'),
      excel.TextCellValue('Remarks'), // 👈 new
    ]);

    for (final issuance in fullData) {
      sheet.appendRow([
        excel.TextCellValue(
          DateFormat('yyyy-MM-dd').format(issuance.issuanceDate),
        ),
        excel.TextCellValue(issuance.issuedTo),
        excel.IntCellValue(issuance.quantity),
        excel.TextCellValue(issuance.remarks ?? ''), // 👈 new
      ]);
    }

    await _saveAndOpenExcel(
      excelFile,
      'issuance_history_${widget.itemName.replaceAll(RegExp(r'[^\w]'), '_')}_${widget.financialYear.replaceAll(' ', '_')}',
    );
  }

  Future<void> _saveAndOpenExcel(excel.Excel excelFile, String baseName) async {
    try {
      Directory? dir;
      final fileName = '$baseName.xlsx';
      bool isAndroid = Platform.isAndroid;
      bool isIOS = Platform.isIOS;

      if (isAndroid) {
        dir = await getDownloadsDirectory();
        dir ??= await getApplicationDocumentsDirectory();
      } else if (isIOS) {
        dir = await getTemporaryDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final path = '${dir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(excelFile.encode()!);

      if (!mounted) return;

      if (isAndroid) {
        _showSnackbar('Saved to: Downloads/$fileName');
        await OpenFilex.open(path);
      } else if (isIOS) {
        _showSnackbar('Opening export...');
        await OpenFilex.open(path);
      } else {
        _showSnackbar('File saved');
        await OpenFilex.open(path);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackbar('Export failed: ${e.toString().split('\n').first}');
      debugPrint('Export error: $e');
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: theme.colorScheme.onSurface.withAlpha(
          (0.8 * 255).toInt(),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.itemName} - ${widget.financialYear}'),
        bottom: TabBar(
          controller: _tabController,
          // Make tabs use custom styled widgets
          tabs: [
            _buildStyledTab(
              'Stock History',
              _tabController.index == 0,
              textTheme,
            ),
            _buildStyledTab(
              'Issuance History',
              _tabController.index == 1,
              textTheme,
            ),
          ],
          // Disable default label styling
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withAlpha((0.7 * 255).toInt()),
          indicatorColor: Colors.white,
          indicatorWeight: 2.0,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: _tabController.index == 0
                ? 'Export Stock History'
                : 'Export Issuance History',
            onPressed: () async {
              if (_tabController.index == 0) {
                final data = await _stockHistoryFuture;
                _exportStockHistory(data);
              } else {
                final data = await _issuanceHistoryFuture;
                _exportIssuanceHistory(data);
              }
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPaginatedTable<StockReceipt>(
            future: _stockHistoryFuture,
            builder: (receipt) => [
              Text(
                DateFormat.yMMMd().format(receipt.receiptDate),
                style: textTheme.bodyMedium,
              ),
              Text(receipt.quantity.toString(), style: textTheme.bodyMedium),
              Text(receipt.remarks ?? '-', style: textTheme.bodyMedium),
            ],
            headers: const ['Date', 'Qty Received', 'Remarks'],
            onPageChanged: (page) => setState(() => _stockCurrentPage = page),
            currentPage: _stockCurrentPage,
            context: context,
          ),
          _buildPaginatedTable<IssuanceRecord>(
            future: _issuanceHistoryFuture,
            builder: (issuance) => [
              Text(
                DateFormat.yMMMd().format(issuance.issuanceDate),
                style: textTheme.bodyMedium,
              ),
              Text(issuance.issuedTo, style: textTheme.bodyMedium),
              Text(issuance.quantity.toString(), style: textTheme.bodyMedium),
              Text(
                issuance.remarks ?? '-',
                style: textTheme.bodyMedium,
              ), // 👈 new column
            ],
            headers: const [
              'Date',
              'Issued To',
              'Qty Issued',
              'Remarks',
            ], // 👈 new header
            onPageChanged: (page) =>
                setState(() => _issuanceCurrentPage = page),
            currentPage: _issuanceCurrentPage,
            context: context,
          ),
        ],
      ),
    );
  }

  // Helper to build a white, weight-aware tab
  Widget _buildStyledTab(String text, bool isSelected, TextTheme textTheme) {
    return Tab(
      child: Text(
        text,
        style: textTheme.titleSmall?.copyWith(
          color: Colors.white, // Always white
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPaginatedTable<T>({
    required BuildContext context,
    required Future<List<T>> future,
    required List<Widget> Function(T) builder,
    required List<String> headers,
    required void Function(int) onPageChanged,
    required int currentPage,
  }) {
    final theme = Theme.of(context);
    final headerStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );

    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(child: Text('No records found.'));
        }

        final totalPages = (data.length / _rowsPerPage).ceil();
        final start = currentPage * _rowsPerPage;
        final pageData = data.skip(start).take(_rowsPerPage).toList();

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(theme.splashColor),
                    dataRowColor: WidgetStateProperty.resolveWith<Color?>((
                      Set<WidgetState> states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return theme.colorScheme.secondary.withAlpha(
                          (0.1 * 255).toInt(),
                        );
                      }
                      return null;
                    }),
                    columns: headers
                        .map(
                          (h) => DataColumn(label: Text(h, style: headerStyle)),
                        )
                        .toList(),
                    rows: pageData.map((item) {
                      return DataRow(
                        cells: builder(item).map((w) => DataCell(w)).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: currentPage > 0
                          ? () {
                              onPageChanged(currentPage - 1);
                            }
                          : null,
                      icon: Icon(
                        Icons.chevron_left,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${currentPage + 1} / $totalPages',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: currentPage < totalPages - 1
                          ? () {
                              onPageChanged(currentPage + 1);
                            }
                          : null,
                      icon: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
