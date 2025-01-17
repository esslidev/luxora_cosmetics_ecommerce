import 'package:equatable/equatable.dart';

import '../../data/models/system_message_translation.dart';

class SystemMessageEntity extends Equatable {
  final int? id;
  final bool? isPublic;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SystemMessageTranslationModel>? translations;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SystemMessageEntity({
    this.id,
    this.isPublic,
    this.startDate,
    this.endDate,
    this.translations,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        isPublic,
        startDate,
        endDate,
        translations,
        createdAt,
        updatedAt,
      ];
}
