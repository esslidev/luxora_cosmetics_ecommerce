import 'package:librairie_alfia/features/domain/entities/author.dart';

abstract class RemoteAuthorEvent {
  const RemoteAuthorEvent();
}

//-----------------------------------------------//
// Update Author
class UpdateAuthor extends RemoteAuthorEvent {
  final AuthorEntity author;

  UpdateAuthor({required this.author});
}

//-----------------------------------------------//
// Delete Author
class DeleteAuthorById extends RemoteAuthorEvent {
  final int id;

  DeleteAuthorById({required this.id});
}

//-----------------------------------------------//
// Get Author by ID
class GetAuthorById extends RemoteAuthorEvent {
  final int id;

  GetAuthorById({required this.id});
}

//-----------------------------------------------//
// Get All Authors
class GetAllAuthors extends RemoteAuthorEvent {
  final int? limit;
  final int? page;
  final String? search;
  final bool? orderByAlphabet;

  GetAllAuthors({
    this.limit,
    this.page,
    this.search,
    this.orderByAlphabet,
  });
}

//-----------------------------------------------//
// Get All Authors
class GetSearchedAuthors extends RemoteAuthorEvent {
  final int? limit;
  final int? page;
  final String? search;
  final bool? orderByAlphabets;

  GetSearchedAuthors({
    this.limit,
    this.page,
    this.search,
    this.orderByAlphabets,
  });
}

//-----------------------------------------------//
// Additional Author Events
class GetAuthorsByNationality extends RemoteAuthorEvent {
  final String nationality;
  final int limit;

  GetAuthorsByNationality({
    required this.nationality,
    this.limit = 10,
  });
}

class GetFeaturedAuthors extends RemoteAuthorEvent {
  final int limit;

  GetFeaturedAuthors({this.limit = 10});
}
