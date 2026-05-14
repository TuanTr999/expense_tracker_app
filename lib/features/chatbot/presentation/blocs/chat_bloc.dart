import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/chat_message_model.dart';
import '../../data/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc(this.repository) : super(ChatState(messages: [])) {
    on<SendMessageEvent>((event, emit) async {
      final userMessage = ChatMessageModel(text: event.message, isUser: true);

      emit(
        state.copyWith(
          messages: [...state.messages, userMessage],
          isLoading: true,
          error: null,
        ),
      );

      try {
        final reply = await repository.sendMessage(event.message);

        final botMessage = ChatMessageModel(text: reply, isUser: false);

        emit(
          state.copyWith(
            messages: [...state.messages, botMessage],
            isLoading: false,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(isLoading: false, error: 'Không thể kết nối Gemini'),
        );
      }
    });
  }
}
