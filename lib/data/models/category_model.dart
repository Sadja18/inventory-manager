import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class Category extends HiveObject {
  /// A unique identifier for the category, typically the category name in lowercase.
  @HiveField(0)
  final String id;

  /// The display name of the category (e.g., "Stationery", "Electronics").
  @HiveField(1)
  String name;

  Category({required this.id, required this.name});
}