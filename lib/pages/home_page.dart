import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:story_narrator/bloc/chat_bloc.dart';
import 'package:story_narrator/models/message_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late FlutterTts flutterTts;
  bool isMicOn = true;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts
        .awaitSpeakCompletion(true); // Ensures narration waits for completion
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _speak(String text) async {
    setState(() {
      isMicOn = false; // Change icon to mic_off when speaking starts
    });
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  Future<void> _stop() async {
    setState(() {
      isMicOn = true; // Change icon back to mic when speaking stops
    });
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          if (state is ChatSuccessState) {
            _scrollToBottom();
          }
        },
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
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                top: 10, left: 10, right: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.purple.withOpacity(0.55),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      messages[index].role == "user"
                                          ? "You"
                                          : "My Narrator",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: messages[index].role == 'user'
                                            ? Colors.yellowAccent
                                            : Colors.green,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: Icon(
                                        isMicOn ? Icons.mic : Icons.mic_off,
                                        color:
                                            isMicOn ? Colors.white : Colors.red,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        if (isMicOn) {
                                          _speak(
                                              messages[index].parts.first.text);
                                        } else {
                                          _stop();
                                        }
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        messages[index].parts.first.text,
                                        style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
                                contentPadding: const EdgeInsets.only(left: 20),
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
                                FocusScope.of(context).unfocus();
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
              return const SizedBox();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }
}
