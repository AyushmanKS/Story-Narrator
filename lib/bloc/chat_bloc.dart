import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_narrator/models/message_model.dart';
import 'package:story_narrator/repos/chat_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }

  List<MessageModel> messages = [];

  FutureOr<void> chatGenerateNewTextMessageEvent(
      ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {
    messages.add(
      (MessageModel(
        role: "user",
        parts: [ChatPartModel(text: event.inputMessage)],
      )),
    );
    emit(ChatSuccessState(messages: messages));
    String generatedText = await ChatRepo.chatTextGenerationRepo(messages);
    if (generatedText.length > 0) {
      messages.add(MessageModel(
          role: 'model', parts: [ChatPartModel(text: generatedText)]));
      emit(ChatSuccessState(messages: messages));
    }
  }
}
