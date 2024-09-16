import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:story_narrator/bloc/chat_bloc.dart';
import 'package:story_narrator/models/message_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<MessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/book.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Story Narrator',
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFfcf5eb),
                            ),
                          ),
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: Lottie.asset("assets/title.json"))
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.purple.withOpacity(0.5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messages[index].role == "user"
                                          ? "You"
                                          : "My Narrator",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: messages[index].role == 'user'
                                            ? Colors.yellowAccent
                                            : Colors.green,
                                      ),
                                    ),
                                    // user given prompts and AI answer
                                    Text(
                                      messages[index].parts.first.text,
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    ),
                    if (chatBloc.generating)
                      Row(
                        children: [
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: Lottie.asset("assets/loader.json")),
                          const SizedBox(
                            width: 20,
                            child: Text(
                              'Writing..',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              style: GoogleFonts.roboto(color: Colors.black),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFfde6d7),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                focusColor: Theme.of(context).primaryColor,
                                hintText: 'Write a story prompt',
                                hintStyle: GoogleFonts.roboto(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                String text = textEditingController.text;
                                textEditingController.clear();
                                chatBloc.add(
                                  ChatGenerateNewTextMessageEvent(
                                      inputMessage: text),
                                );
                              }
                            },
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.brown,
                              child: CircleAvatar(
                                radius: 26,
                                backgroundColor: Color(0xFFfde6d7),
                                child: Icon(
                                  Icons.send,
                                  color: Colors.brown,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
