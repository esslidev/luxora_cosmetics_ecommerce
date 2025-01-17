import 'package:uuid/uuid.dart';

class BreadCrumbModel {
  static const Uuid _uuid = Uuid();

  final String id;
  final String name;
  final String? path;

  // Private constructor
  BreadCrumbModel({required this.name, this.path}) : id = _uuid.v4();
}
