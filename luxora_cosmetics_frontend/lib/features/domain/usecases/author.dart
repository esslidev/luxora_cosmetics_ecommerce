import '../../../core/resources/data_state.dart';
import '../entities/author.dart';
import '../repository/author.dart';

class AuthorUseCases {
  final AuthorRepository repository;

  AuthorUseCases(this.repository);

  Future<DataState<AuthorEntity>> updateAuthor({
    required AuthorEntity author,
  }) async {
    return await repository.updateAuthor(author: author);
  }

  Future<DataState> deleteAuthorById({
    required int id,
  }) async {
    return await repository.deleteAuthorById(id: id);
  }

  Future<DataState<AuthorEntity>> getAuthorById({
    required int id,
  }) async {
    return await repository.getAuthorById(id: id);
  }

  Future<DataState<List<AuthorEntity>>> getAuthors({
    String? search,
    bool? orderByAlphabets,
    bool? isAuthorOfMonth,
    bool? isFeaturedAuthor,
    bool? orderByName,
  }) async {
    return await repository.getAuthors(
      search: search,
      isAuthorOfMonth: isAuthorOfMonth,
      isFeaturedAuthor: isFeaturedAuthor,
      orderByName: orderByName,
    );
  }
}
