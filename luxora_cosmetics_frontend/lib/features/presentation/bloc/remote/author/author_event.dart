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
class GetAuthors extends RemoteAuthorEvent {
  final String? search;
  final bool? isAuthorOfMonth;
  final bool? isFeaturedAuthor;
  final bool? orderByName;

  GetAuthors({
    this.search,
    this.isAuthorOfMonth,
    this.isFeaturedAuthor,
    this.orderByName,
  });
}

//-----------------------------------------------//
// Get All Authors
class GetSearchedAuthors extends RemoteAuthorEvent {
  final String? search;

  GetSearchedAuthors({
    this.search,
  });
}

//-----------------------------------------------//
// Get All Authors
class GetBoutiqueFeaturedAuthors extends RemoteAuthorEvent {
  GetBoutiqueFeaturedAuthors();
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
