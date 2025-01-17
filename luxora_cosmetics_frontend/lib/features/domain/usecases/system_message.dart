import '../../../core/resources/data_state.dart';
import '../../data/models/system_message.dart';
import '../entities/system_message.dart';
import '../repository/system_message.dart';

class SystemMessageUseCases {
  final SystemMessageRepository repository;

  SystemMessageUseCases(this.repository);

  Future<DataState<SystemMessageEntity>> createSystemMessage({
    required SystemMessageModel systemMessage,
  }) async {
    return await repository.createSystemMessage(systemMessage: systemMessage);
  }

  Future<DataState<SystemMessageEntity>> updateSystemMessage({
    required SystemMessageModel systemMessage,
  }) async {
    return await repository.updateSystemMessage(systemMessage: systemMessage);
  }

  Future<DataState> deleteSystemMessage({
    required int id,
  }) async {
    return await repository.deleteSystemMessage(id: id);
  }

  Future<DataState<List<SystemMessageEntity>>> getAllSystemMessages() async {
    return await repository.getAllSystemMessages();
  }

  Future<DataState<List<SystemMessageEntity>>> getShownSystemMessages() async {
    return await repository.getShownSystemMessages();
  }
}
