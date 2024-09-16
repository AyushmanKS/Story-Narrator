import 'package:dio/dio.dart';
import 'package:story_narrator/consts.dart';
import 'package:story_narrator/models/message_model.dart';

class ChatRepo {
  // creating new chat by keeping inmemory prev chat messages
  static chatTextGenerationRepo(List<MessageModel> prevMessages) async {
    try {
      Dio dio = Dio();

      final response = dio.post(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${API_KEY}",
          data: {
            "contents": prevMessages.map((e) => e.toMap()).toList(),
            "generationConfig": {
              "temperature": 2,
              "topK": 64,
              "topP": 0.95,
              "maxOutputTokens": 8192,
              "responseMimeType": "text/plain"
            }
          });
      print('response from API-----------------${response.toString()}');
    } catch (e) {
      print(
          "error while fetching data from API:---------------------------${e.toString()}");
    }
  }
}
