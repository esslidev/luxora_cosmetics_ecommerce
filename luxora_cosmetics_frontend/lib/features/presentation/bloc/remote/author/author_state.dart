import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/author.dart';

abstract class RemoteAuthorState extends Equatable {
  final AuthorEntity? author;
  final List<AuthorEntity>? authors;
  final List<AuthorEntity>? searchedAuthors;
  final List<AuthorEntity>? boutiqueFeaturedAuthors;
  final bool? authorLoading;
  final bool? authorsLoading;
  final bool? searchedAuthorsLoading;
  final bool? boutiqueFeaturedAuthorsLoading;
  final String? messageResponse;
  final DioException? error;

  const RemoteAuthorState({
    this.author,
    this.authors,
    this.searchedAuthors,
    this.boutiqueFeaturedAuthors,
    this.authorLoading,
    this.authorsLoading,
    this.searchedAuthorsLoading,
    this.boutiqueFeaturedAuthorsLoading,
    this.messageResponse,
    this.error,
  });

  @override
  List<Object?> get props => [
        author,
        authors,
        searchedAuthors,
        boutiqueFeaturedAuthors,
        authorLoading,
        authorsLoading,
        searchedAuthorsLoading,
        boutiqueFeaturedAuthorsLoading,
        messageResponse,
        error,
      ];
}

// ------------- Initial author state -------------- //
class RemoteAuthorInitial extends RemoteAuthorState {
  const RemoteAuthorInitial();
}

// ------------- Updating author -------------- //
class RemoteAuthorUpdating extends RemoteAuthorState {
  const RemoteAuthorUpdating();
}

class RemoteAuthorUpdated extends RemoteAuthorState {
  const RemoteAuthorUpdated(AuthorEntity? author) : super(author: author);
}

// ------------- Deleting author -------------- //
class RemoteAuthorDeleting extends RemoteAuthorState {
  const RemoteAuthorDeleting();
}

class RemoteAuthorDeleted extends RemoteAuthorState {
  const RemoteAuthorDeleted(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- Loading author -------------- //
class RemoteAuthorLoading extends RemoteAuthorState {
  const RemoteAuthorLoading({super.authorLoading});
}

class RemoteAuthorLoaded extends RemoteAuthorState {
  const RemoteAuthorLoaded(AuthorEntity? author) : super(author: author);
}

// ------------- Loading authors -------------- //
class RemoteAuthorsLoading extends RemoteAuthorState {
  const RemoteAuthorsLoading(
      {super.authorsLoading,
      super.searchedAuthorsLoading,
      super.boutiqueFeaturedAuthorsLoading});
}

class RemoteAuthorsLoaded extends RemoteAuthorState {
  const RemoteAuthorsLoaded({
    super.authors,
    super.searchedAuthors,
    super.boutiqueFeaturedAuthors,
  });
}

// ------------- Error author -------------- //
class RemoteAuthorError extends RemoteAuthorState {
  const RemoteAuthorError(DioException? error) : super(error: error);
}
