import 'package:dart_openai/dart_openai.dart';

class OpenaiHandler {
   
    // basic function: User states how they are feeling; what they want. Model
    // generates search query based on that recommendation and returns results.
    static Future<String> getSearchRecommendation(String userDesire) async {
      try {
        final systemMessage = OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "Your job is to recieve a user desire and, based on their wants, create a search query for a local veteran owned business."
            ),
          ],
          role: OpenAIChatMessageRole.system,
        );

        final userMessage = OpenAIChatCompletionChoiceMessageModel(
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
              "User Desire: $userDesire"
            )
          ],
          role: OpenAIChatMessageRole.user
        );

        OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          responseFormat: {"type": "json_object"},
          seed: 6,
          messages: [
            systemMessage,
            userMessage
          ],
          temperature: 0.2,
          maxTokens: 500
        );
      return chatCompletion.choices.first.message.content.toString();
      } catch (e) {
        print("OpenAI request failed: $e");
        return "";
      }
    }
}
