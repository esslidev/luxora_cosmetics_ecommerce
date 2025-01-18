import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/category.dart';

abstract class RemoteCategoryState extends Equatable {
  final CategoryEntity? category;
  final CategoryEntity? boutiqueCategory;
  final List<CategoryEntity>? categories;
  final List<CategoryEntity>? subCategories;
  final List<CategoryEntity>? navigatorAllCategories;
  final List<CategoryEntity>? boutiqueAllCategories;
  final List<CategoryEntity>? searchMainCategories;
  final bool? boutiqueCategoryLoading;
  final bool? navigatorAllCategoriesLoading;
  final bool? boutiqueAllCategoriesLoading;
  final bool? searchMainCategoriesLoading;
  final String? messageResponse;
  final DioException? error;

  const RemoteCategoryState({
    this.category,
    this.boutiqueCategory,
    this.categories,
    this.subCategories,
    this.navigatorAllCategories,
    this.boutiqueAllCategories,
    this.boutiqueCategoryLoading,
    this.searchMainCategories,
    this.navigatorAllCategoriesLoading,
    this.boutiqueAllCategoriesLoading,
    this.searchMainCategoriesLoading,
    this.messageResponse,
    this.error,
  });

  @override
  List<Object?> get props => [
        category,
        boutiqueCategory,
        categories,
        subCategories,
        navigatorAllCategories,
        boutiqueCategoryLoading,
        navigatorAllCategoriesLoading,
        boutiqueAllCategoriesLoading,
        messageResponse,
        error,
      ];
}

// ------------- Initial State -------------- //
class RemoteCategoryInitial extends RemoteCategoryState {
  const RemoteCategoryInitial();
}

// ------------- Creating Category -------------- //
class RemoteCategoryCreating extends RemoteCategoryState {
  const RemoteCategoryCreating();
}

class RemoteCategoryCreated extends RemoteCategoryState {
  const RemoteCategoryCreated(CategoryEntity? category)
      : super(category: category);
}

// ------------- Updating Category -------------- //
class RemoteCategoryUpdating extends RemoteCategoryState {
  const RemoteCategoryUpdating();
}

class RemoteCategoryUpdated extends RemoteCategoryState {
  const RemoteCategoryUpdated(CategoryEntity? category)
      : super(category: category);
}

// ------------- Deleting Category -------------- //
class RemoteCategoryDeleting extends RemoteCategoryState {
  const RemoteCategoryDeleting();
}

class RemoteCategoryDeleted extends RemoteCategoryState {
  const RemoteCategoryDeleted(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- Loading Single Category -------------- //
class RemoteCategoryLoading extends RemoteCategoryState {
  const RemoteCategoryLoading({super.boutiqueCategoryLoading});
}

class RemoteCategoryLoaded extends RemoteCategoryState {
  const RemoteCategoryLoaded({super.category, super.boutiqueCategory});
}

// ------------- Loading Multiple Categories -------------- //
class RemoteMainCategoriesLoading extends RemoteCategoryState {
  const RemoteMainCategoriesLoading({super.searchMainCategoriesLoading});
}

class RemoteMainCategoriesLoaded extends RemoteCategoryState {
  const RemoteMainCategoriesLoaded({super.searchMainCategories});
}

// ------------- Loading Multiple Categories -------------- //
class RemoteCategoriesLoading extends RemoteCategoryState {
  const RemoteCategoriesLoading(
      {super.navigatorAllCategoriesLoading,
      super.boutiqueAllCategoriesLoading});
}

class RemoteCategoriesLoaded extends RemoteCategoryState {
  const RemoteCategoriesLoaded({
    super.categories,
    super.subCategories,
    super.navigatorAllCategories,
    super.boutiqueAllCategories,
  });
}

// ------------- Error State -------------- //
class RemoteCategoryError extends RemoteCategoryState {
  const RemoteCategoryError(DioException? error) : super(error: error);
}
