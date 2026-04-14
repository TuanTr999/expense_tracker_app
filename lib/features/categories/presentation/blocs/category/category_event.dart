import 'package:expense_tracker_app/core/enums/app_type.dart';

import '../../../data/models/category_model.dart';

abstract class CategoryEvent {}

class LoadCategoryEvent extends CategoryEvent {}

class LoadCategoryByTypeEvent extends CategoryEvent {
  final AppType type;

  LoadCategoryByTypeEvent(this.type);
}

class AddCategoryEvent extends CategoryEvent {
  final CategoryModel category;

  AddCategoryEvent(this.category);
}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryModel category;

  UpdateCategoryEvent(this.category);
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  DeleteCategoryEvent(this.id);
}

class ResetCategoryEvent extends CategoryEvent {}
