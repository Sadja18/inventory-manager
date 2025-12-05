import 'dart:io';
import 'package:excel/excel.dart' as excel;
import 'package:flutter/material.dart';
import 'package:myapp/data/report_generator.dart';
import 'package:myapp/navigation_routes.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? _selectedFy;
  List<String> _financialYears = [];
  final ReportGenerator _reportGenerator = ReportGenerator();
  Future<List<Map<String, dynamic>>>? _reportDataFuture;
  List<Map<String, dynamic>> _currentReportData = [];

  @override
  void initState() {
    super.initState();
    _financialYears = _getFinancialYears();
    if (_financialYears.isNotEmpty) {
      _selectedFy = _financialYears.first;
      _loadReportData();
    }
  }

  void _loadReportData() {
    if (_selectedFy != null) {
      setState(() {
        _reportDataFuture = _reportGenerator.getReportData(_selectedFy!);
      });
    }
  }

  List<String> _getFinancialYears() {
    final List<String> years = [];
    final now = DateTime.now();
    int currentYear = now.year;
    if (now.month < 4) {
      currentYear--;
    }
    for (int i = 0; i < 5; i++) {
      years.add(
        'FY ${currentYear - i}-${(currentYear - i + 1).toString().substring(2)}',
      );
    }
    return years;
  }

  Future<void> _exportToExcel() async {
    if (_currentReportData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No data to export.')));
      return;
    }

    final excelFile = excel.Excel.createExcel();
    final sheet = excelFile['Sheet1'];

    // Add header row
    sheet.appendRow([
      excel.TextCellValue('S.No'),
      excel.TextCellValue('Item Name'),
      excel.TextCellValue('Receipt Qty'),
      excel.TextCellValue('Issued Qty'),
      excel.TextCellValue('Balance Qty'),
    ]);

    // Add data rows
    for (var item in _currentReportData) {
      sheet.appendRow([
        excel.IntCellValue(item['s_no'] ?? 0),
        excel.TextCellValue(item['item_name'] ?? ''),
        excel.IntCellValue(item['receipt_qty'] ?? 0),
        excel.IntCellValue(item['issued_qty'] ?? 0),
        excel.IntCellValue(item['balance_qty'] ?? 0),
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/report_${_selectedFy!.replaceAll(' ', '_')}.xlsx';
    final file = File(path);
    await file.writeAsBytes(excelFile.encode()!);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Report saved to $path')));

    OpenFilex.open(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reports'),
        elevation: 0,
        backgroundColor: theme.canvasColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: _exportToExcel,
            tooltip: 'Export to Excel',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFinancialYearDropdown(theme),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _reportDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  _currentReportData = [];
                  return const Center(
                    child: Text(
                      'No report data available for the selected year.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
                _currentReportData = snapshot.data!;
                return _buildReportTable(_currentReportData, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialYearDropdown(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFy,
          isExpanded: true,
          icon: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
          items: _financialYears.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: theme.textTheme.titleMedium),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                _selectedFy = newValue;
                _loadReportData();
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildReportTable(List<Map<String, dynamic>> data, ThemeData theme) {
    final headerStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    );
    final cellStyle = theme.textTheme.bodyMedium;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
          ),
          child: DataTable(
            columnSpacing: 30.0,
            headingRowColor: WidgetStateProperty.all(theme.splashColor),
            columns: [
              DataColumn(label: Text('S.No', style: headerStyle)),
              DataColumn(label: Text('Item Name', style: headerStyle)),
              DataColumn(
                label: Text('Receipt Qty', style: headerStyle),
                numeric: true,
              ),
              DataColumn(
                label: Text('Issued Qty', style: headerStyle),
                numeric: true,
              ),
              DataColumn(
                label: Text('Balance Qty', style: headerStyle),
                numeric: true,
              ),
              DataColumn(label: Text('History', style: headerStyle)),
            ],
            rows: data.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item['s_no'].toString(), style: cellStyle)),
                  DataCell(Text(item['item_name'], style: cellStyle)),
                  DataCell(
                    Text(item['receipt_qty'].toString(), style: cellStyle),
                  ),
                  DataCell(
                    Text(item['issued_qty'].toString(), style: cellStyle),
                  ),
                  DataCell(
                    Text(item['balance_qty'].toString(), style: cellStyle),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.itemHistory,
                          arguments: {
                            'itemId': item['item_id'],
                            'itemName': item['item_name'],
                            'financialYear': _selectedFy!,
                          },
                        );
                      },
                      tooltip: 'View Item History',
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
