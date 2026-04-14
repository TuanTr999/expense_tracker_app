
import '../../../../core/enums/app_type.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final AppType type;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.type
  });

  static AppType typeFromString(String value) {
    switch (value) {
      case 'income':
        return AppType.income;
      case 'expense':
        return AppType.expense;
      default:
        return AppType.expense;
    }
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      type: typeFromString(map['type']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type.name
    };
  }
}