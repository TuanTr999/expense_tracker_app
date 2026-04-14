import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository)
      : super(CategoryState(categories: [])) {

    on<LoadCategoryEvent>((event, emit) async {
      final data = await repository.getCategories();
      emit(state.copyWith(categories: data));
    });

    on<LoadCategoryByTypeEvent>((event, emit) async {
      final data = await repository.getCategoriesByType(event.type);

      emit(state.copyWith(
        categories: data,
        selectedType: event.type,
      ));
    });

    on<AddCategoryEvent>((event, emit) async {
      await repository.insertCategory(event.category);

      final data = state.selectedType != null
          ? await repository.getCategoriesByType(state.selectedType!)
          : await repository.getCategories();

      emit(state.copyWith(categories: data));
    });

    on<UpdateCategoryEvent>((event, emit) async {
      await repository.updateCategory(event.category);

      final data = state.selectedType != null
          ? await repository.getCategoriesByType(state.selectedType!)
          : await repository.getCategories();

      emit(state.copyWith(categories: data));
    });

    on<DeleteCategoryEvent>((event, emit) async {
      await repository.deleteCategory(event.id);

      final data = state.selectedType != null
          ? await repository.getCategoriesByType(state.selectedType!)
          : await repository.getCategories();

      emit(state.copyWith(categories: data));
    });
  }
}