import '../../../../data/models/system_message.dart';

abstract class RemoteSystemMessageEvent {
  const RemoteSystemMessageEvent();
}

// Event to create a new system message
class CreateSystemMessage extends RemoteSystemMessageEvent {
  final SystemMessageModel systemMessage;

  CreateSystemMessage(this.systemMessage);
}

// Event to update an existing system message
class UpdateSystemMessage extends RemoteSystemMessageEvent {
  final SystemMessageModel systemMessage;

  UpdateSystemMessage(this.systemMessage);
}

// Event to delete a system message
class DeleteSystemMessage extends RemoteSystemMessageEvent {
  final int id;

  DeleteSystemMessage(this.id);
}

// Event to fetch all system messages
class GetAllSystemMessages extends RemoteSystemMessageEvent {
  const GetAllSystemMessages();
}

// Event to fetch shown (unexpired) system messages
class GetShownSystemMessages extends RemoteSystemMessageEvent {
  const GetShownSystemMessages();
}
