import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../domain/usecases/system_message.dart';
import 'system_message_event.dart';
import 'system_message_state.dart';

class RemoteSystemMessageBloc
    extends Bloc<RemoteSystemMessageEvent, RemoteSystemMessageState> {
  final SystemMessageUseCases _systemMessageUseCases;

  RemoteSystemMessageBloc(this._systemMessageUseCases)
      : super(const RemoteSystemMessageInitial()) {
    on<CreateSystemMessage>(onCreateSystemMessage);
    on<UpdateSystemMessage>(onUpdateSystemMessage);
    on<DeleteSystemMessage>(onDeleteSystemMessage);
    on<GetAllSystemMessages>(onGetAllSystemMessages);
    on<GetShownSystemMessages>(onGetShownSystemMessages);
  }

  // Create a new system message
  void onCreateSystemMessage(
      CreateSystemMessage event, Emitter<RemoteSystemMessageState> emit) async {
    emit(const RemoteSystemMessageSaving());
    final dataState = await _systemMessageUseCases.createSystemMessage(
        systemMessage: event.systemMessage);

    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteSystemMessageSaved(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(RemoteSystemMessageError(dataState.error!));
    }
  }

  // Update an existing system message
  void onUpdateSystemMessage(
      UpdateSystemMessage event, Emitter<RemoteSystemMessageState> emit) async {
    emit(const RemoteSystemMessageUpdating());
    final dataState = await _systemMessageUseCases.updateSystemMessage(
        systemMessage: event.systemMessage);

    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteSystemMessageUpdated(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(RemoteSystemMessageError(dataState.error!));
    }
  }

  // Delete a system message
  void onDeleteSystemMessage(
      DeleteSystemMessage event, Emitter<RemoteSystemMessageState> emit) async {
    emit(const RemoteSystemMessageDeleting());
    final dataState =
        await _systemMessageUseCases.deleteSystemMessage(id: event.id);

    if (dataState is DataSuccess && dataState.message != null) {
      emit(RemoteSystemMessageDeleted(dataState.message!));
    }
    if (dataState is DataFailed) {
      emit(RemoteSystemMessageError(dataState.error!));
    }
  }

  // Fetch all system messages
  void onGetAllSystemMessages(GetAllSystemMessages event,
      Emitter<RemoteSystemMessageState> emit) async {
    emit(const RemoteAllSystemMessagesLoading());
    final dataState = await _systemMessageUseCases.getAllSystemMessages();

    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteAllSystemMessagesLoaded(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(RemoteSystemMessageError(dataState.error!));
    }
  }

  // Fetch only shown (unexpired) system messages
  void onGetShownSystemMessages(GetShownSystemMessages event,
      Emitter<RemoteSystemMessageState> emit) async {
    emit(const RemoteShownSystemMessagesLoading());
    final dataState = await _systemMessageUseCases.getShownSystemMessages();

    if (dataState is DataSuccess && dataState.data != null) {
      emit(RemoteShownSystemMessagesLoaded(dataState.data!));
    }
    if (dataState is DataFailed) {
      emit(RemoteSystemMessageError(dataState.error!));
    }
  }
}
