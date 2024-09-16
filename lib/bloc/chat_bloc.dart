import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:story_narrator/models/message_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });

    List<MessageModel> messages = [];
  }
}
