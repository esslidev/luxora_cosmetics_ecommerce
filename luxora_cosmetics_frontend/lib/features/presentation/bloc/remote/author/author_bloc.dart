import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/author.dart';
import 'author_event.dart';
import 'author_state.dart';

class RemoteAuthorBloc extends Bloc<RemoteAuthorEvent, RemoteAuthorState> {
  final AuthorUseCases _authorUseCases;

  RemoteAuthorBloc(this._authorUseCases) : super(const RemoteAuthorInitial()) {
    on<UpdateAuthor>(onUpdateAuthor);
    on<DeleteAuthorById>(onDeleteAuthorById);
    on<GetAuthorById>(onGetAuthorById);
    on<GetAuthors>(onGetAuthors);
    on<GetSearchedAuthors>(onGetSearchedAuthors);
    on<GetBoutiqueFeaturedAuthors>(onGetBoutiqueFeaturedAuthors);
  }

  void onUpdateAuthor(
      UpdateAuthor event, Emitter<RemoteAuthorState> emit) async {
    emit(const RemoteAuthorUpdating());
    final dataState = await _authorUseCases.updateAuthor(author: event.author);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteAuthorUpdated(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthorError(dataState.error!));
    }
  }

  void onDeleteAuthorById(
      DeleteAuthorById event, Emitter<RemoteAuthorState> emit) async {
    emit(const RemoteAuthorDeleting());
    final dataState = await _authorUseCases.deleteAuthorById(id: event.id);
    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteAuthorDeleted(dataState.message!));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthorError(dataState.error!));
    }
  }

  void onGetAuthorById(
      GetAuthorById event, Emitter<RemoteAuthorState> emit) async {
    emit(const RemoteAuthorLoading(authorLoading: true));
    final dataState = await _authorUseCases.getAuthorById(id: event.id);
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteAuthorLoaded(dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthorError(dataState.error!));
    }
  }

  void onGetAuthors(GetAuthors event, Emitter<RemoteAuthorState> emit) async {
    emit(const RemoteAuthorsLoading(authorsLoading: true));
    final dataState = await _authorUseCases.getAuthors(
      search: event.search,
      isAuthorOfMonth: event.isAuthorOfMonth,
      isFeaturedAuthor: event.isFeaturedAuthor,
      orderByName: event.orderByName,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteAuthorsLoaded(authors: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthorError(dataState.error!));
    }
  }

  void onGetSearchedAuthors(
      GetSearchedAuthors event, Emitter<RemoteAuthorState> emit) async {
    emit(const RemoteAuthorsLoading(searchedAuthorsLoading: true));
    final dataState = await _authorUseCases.getAuthors(
      search: event.search,
      orderByAlphabets: true,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteAuthorsLoaded(searchedAuthors: dataState.data));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthorError(dataState.error!));
    }
  }

  void onGetBoutiqueFeaturedAuthors(
      GetBoutiqueFeaturedAuthors event, Emitter<RemoteAuthorState> emit) async {
    emit(const RemoteAuthorsLoading(authorsLoading: true));
    final dataState = await _authorUseCases.getAuthors(
      isFeaturedAuthor: true,
      orderByName: true,
    );
    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteAuthorsLoaded(boutiqueFeaturedAuthors: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(RemoteAuthorError(dataState.error!));
    }
  }
}
