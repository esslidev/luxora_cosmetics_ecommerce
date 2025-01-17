import '../../../core/resources/data_state.dart';
import '../entities/author.dart';

abstract class AuthorRepository {
  Future<DataState<AuthorEntity>> updateAuthor({
    required AuthorEntity author,
  });

  Future<DataState> deleteAuthorById({
    required int id,
  });

  Future<DataState<AuthorEntity>> getAuthorById({
    required int id,
  });

  Future<DataState<List<AuthorEntity>>> getAuthors({
    String? search,
    bool? isAuthorOfMonth,
    bool? isFeaturedAuthor,
    bool? orderByName,
  });
}
