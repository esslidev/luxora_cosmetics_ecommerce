import 'package:equatable/equatable.dart';
import 'package:librairie_alfia/features/data/models/product.dart';

class AuthorEntity extends Equatable {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? coverImageUrl;
  final bool? authorOfMonth;
  final bool? featuredAuthor;
  final List<ProductModel>? products;

  const AuthorEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.coverImageUrl,
    this.authorOfMonth,
    this.featuredAuthor,
    this.products,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        coverImageUrl,
        authorOfMonth,
        featuredAuthor,
        products,
      ];
}
