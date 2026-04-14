import '../../../data/models/category_model.dart';

abstract class CategoryEvent {}

class LoadCategoryEvent extends CategoryEvent {}

class LoadCategoryByTypeEvent extends CategoryEvent {
  final String type;

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
  final String id;

  DeleteCategoryEvent(this.id);
}

class ResetCategoryEvent extends CategoryEvent {}
