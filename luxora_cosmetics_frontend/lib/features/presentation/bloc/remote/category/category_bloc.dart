import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/category.dart';
import 'category_event.dart';
import 'category_state.dart';

class RemoteCategoryBloc
    extends Bloc<RemoteCategoryEvent, RemoteCategoryState> {
  final CategoryUseCases _categoryUseCases;

  RemoteCategoryBloc(this._categoryUseCases)
      : super(const RemoteCategoryInitial()) {
    on<CreateCategory>(onCreateCategory);
    on<UpdateCategory>(onUpdateCategory);
    on<DeleteCategoryById>(onDeleteCategoryById);
    on<DeleteCategoryByCategoryNumber>(onDeleteCategoryByCategoryNumber);
    on<GetCategoryById>(onGetCategoryById);
    on<GetCategoryByCategoryNumber>(onGetCategoryByCategoryNumber);
    on<GetBoutiqueMainCategory>(onGetBoutiqueMainCategory);
    on<GetNavigatorAllCategories>(onGetNavigatorAllCategories);
    on<GetBoutiqueAllCategories>(onGetBoutiqueAllCategories);
    on<GetSearchMainCategories>(onGetSearchMainCategories);
    on<GetCategories>(onGetCategories);
  }

  void onCreateCategory(
      CreateCategory event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryCreating());
    final dataState =
        await _categoryUseCases.createCategory(category: event.category);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoryCreated(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onUpdateCategory(
      UpdateCategory event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryUpdating());
    final dataState =
        await _categoryUseCases.updateCategory(category: event.category);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoryUpdated(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onDeleteCategoryById(
      DeleteCategoryById event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryDeleting());
    final dataState = await _categoryUseCases.deleteCategory(id: event.id);
    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteCategoryDeleted(dataState.message!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onDeleteCategoryByCategoryNumber(DeleteCategoryByCategoryNumber event,
      Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryDeleting());
    final dataState = await _categoryUseCases.deleteCategory(
        categoryNumber: event.categoryNumber);
    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteCategoryDeleted(dataState.message!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetCategoryById(
      GetCategoryById event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryLoading());
    final dataState = await _categoryUseCases.getCategory(id: event.id);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoryLoaded(category: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetCategoryByCategoryNumber(GetCategoryByCategoryNumber event,
      Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryLoading());
    final dataState = await _categoryUseCases.getCategory(
        categoryNumber: event.categoryNumber);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoryLoaded(category: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetBoutiqueMainCategory(
      GetBoutiqueMainCategory event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoryLoading(boutiqueCategoryLoading: true));
    final dataState = await _categoryUseCases.getCategory(
        categoryNumber: event.categoryNumber);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoryLoaded(boutiqueCategory: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetNavigatorAllCategories(GetNavigatorAllCategories event,
      Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoriesLoading(navigatorAllCategoriesLoading: true));
    final dataState = await _categoryUseCases.getAllCategories(
      level: 2,
      isMainCategory: true,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoriesLoaded(navigatorAllCategories: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetBoutiqueAllCategories(
      GetBoutiqueAllCategories event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoriesLoading(boutiqueAllCategoriesLoading: true));
    final dataState = await _categoryUseCases.getAllCategories(
      isMainCategory: true,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoriesLoaded(boutiqueAllCategories: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetSearchMainCategories(
      GetSearchMainCategories event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteMainCategoriesLoading(searchMainCategoriesLoading: true));
    final dataState = await _categoryUseCases.getMainCategories(
      ids: event.ids,
      categoryNumbers: event.categoryNumbers,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteMainCategoriesLoaded(searchMainCategories: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }

  void onGetCategories(
      GetCategories event, Emitter<RemoteCategoryState> emit) async {
    emit(const RemoteCategoriesLoading());
    final dataState = await _categoryUseCases.getCategories(
      ids: event.ids,
      categoryNumbers: event.categoryNumbers,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteCategoriesLoaded(categories: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteCategoryError(dataState.error!));
    }
  }
}
