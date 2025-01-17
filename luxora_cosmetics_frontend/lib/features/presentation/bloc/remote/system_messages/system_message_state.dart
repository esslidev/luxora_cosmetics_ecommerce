import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:librairie_alfia/features/domain/entities/system_message.dart';

abstract class RemoteSystemMessageState extends Equatable {
  final SystemMessageEntity? systemMessage;
  final List<SystemMessageEntity>? systemAllMessages;
  final List<SystemMessageEntity>? systemShownMessages;
  final String? messageResponse;
  final DioException? error;

  const RemoteSystemMessageState(
      {this.systemMessage,
      this.systemAllMessages,
      this.systemShownMessages,
      this.messageResponse,
      this.error});

  @override
  List<Object?> get props => [
        systemMessage,
        systemAllMessages,
        systemShownMessages,
        messageResponse,
        error,
      ];
}

// ------------- init system message --------------//
class RemoteSystemMessageInitial extends RemoteSystemMessageState {
  const RemoteSystemMessageInitial();
}

// ------------- saving system message --------------//
class RemoteSystemMessageSaving extends RemoteSystemMessageState {
  const RemoteSystemMessageSaving();
}

class RemoteSystemMessageSaved extends RemoteSystemMessageState {
  const RemoteSystemMessageSaved(SystemMessageEntity? systemMessage)
      : super(systemMessage: systemMessage);
}

// ------------- updating system message --------------//
class RemoteSystemMessageUpdating extends RemoteSystemMessageState {
  const RemoteSystemMessageUpdating();
}

class RemoteSystemMessageUpdated extends RemoteSystemMessageState {
  const RemoteSystemMessageUpdated(SystemMessageEntity? systemMessage)
      : super(systemMessage: systemMessage);
}

// ------------- deleting system message --------------//
class RemoteSystemMessageDeleting extends RemoteSystemMessageState {
  const RemoteSystemMessageDeleting();
}

class RemoteSystemMessageDeleted extends RemoteSystemMessageState {
  const RemoteSystemMessageDeleted(String? messageResponse)
      : super(messageResponse: messageResponse);
}

// ------------- loading all system messages --------------//
class RemoteAllSystemMessagesLoading extends RemoteSystemMessageState {
  const RemoteAllSystemMessagesLoading();
}

class RemoteAllSystemMessagesLoaded extends RemoteSystemMessageState {
  const RemoteAllSystemMessagesLoaded(
      List<SystemMessageEntity>? systemAllMessages)
      : super(systemAllMessages: systemAllMessages);
}

// ------------- loading shown system messages --------------//
class RemoteShownSystemMessagesLoading extends RemoteSystemMessageState {
  const RemoteShownSystemMessagesLoading();
}

class RemoteShownSystemMessagesLoaded extends RemoteSystemMessageState {
  const RemoteShownSystemMessagesLoaded(
      List<SystemMessageEntity>? systemShownMessages)
      : super(systemShownMessages: systemShownMessages);
}

// ------------- Error system message --------------//
class RemoteSystemMessageError extends RemoteSystemMessageState {
  const RemoteSystemMessageError(DioException? error) : super(error: error);
}
