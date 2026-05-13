import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/features/categories/data/models/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryState(categories: [])) {
    on<LoadCategoryEvent>(_onLoadCategories);
    on<LoadCategoryByTypeEvent>(_onLoadCategoriesByType);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<ResetCategoryEvent>(_onResetCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      final data = await repository.getCategories();

      emit(state.copyWith(
        categories: data,
        status: AppStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onLoadCategoriesByType(
      LoadCategoryByTypeEvent event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      final data = await repository.getCategoriesByType(event.type);

      emit(state.copyWith(
        categories: data,
        selectedType: event.type,
        status: AppStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onAddCategory(
      AddCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.insertCategory(event.category);

      final data = await _reloadCurrentCategories();

      emit(state.copyWith(
        categories: data,
        status: AppStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.updateCategory(event.category);

      final data = await _reloadCurrentCategories();

      emit(state.copyWith(
        categories: data,
        status: AppStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.deleteCategory(event.id);

      final data = await _reloadCurrentCategories();

      emit(state.copyWith(
        categories: data,
        status: AppStatus.deleted,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<void> _onResetCategory(
      ResetCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));

      await repository.resetCategory();

      final data = await _reloadCurrentCategories();

      emit(state.copyWith(
        categories: data,
        status: AppStatus.deleted,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error));
    }
  }

  Future<List<CategoryModel>> _reloadCurrentCategories() {
    if (state.selectedType != null) {
      return repository.getCategoriesByType(state.selectedType!);
    }

    return repository.getCategories();
  }
}