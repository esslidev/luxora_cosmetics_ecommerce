import '../../../core/resources/data_state.dart';
import '../../data/models/system_message.dart';
import '../entities/system_message.dart';

abstract class SystemMessageRepository {
  Future<DataState<SystemMessageEntity>> createSystemMessage({
    required SystemMessageModel systemMessage,
  });

  Future<DataState<SystemMessageEntity>> updateSystemMessage({
    required SystemMessageModel systemMessage,
  });

  Future<DataState> deleteSystemMessage({
    required int id,
  });

  Future<DataState<List<SystemMessageEntity>>> getAllSystemMessages();

  Future<DataState<List<SystemMessageEntity>>> getShownSystemMessages();
}
