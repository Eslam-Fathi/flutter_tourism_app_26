import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AIMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class AIChatState {
  final List<AIMessage> messages;
  final bool isLoading;

  AIChatState({
    required this.messages,
    this.isLoading = false,
  });

  AIChatState copyWith({
    List<AIMessage>? messages,
    bool? isLoading,
  }) {
    return AIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AIChatNotifier extends StateNotifier<AIChatState> {
  late final GenerativeModel _model;
  late final ChatSession _chat;

  AIChatNotifier() : super(AIChatState(messages: [])) {
    _initChat();
  }

  void _initChat() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      state = state.copyWith(
        messages: [
          AIMessage(
            text: 'Error: Gemini API Key is missing. Please add it to your .env file.',
            isUser: false,
            timestamp: DateTime.now(),
          )
        ],
      );
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(
        "You are 'SeYaha AI', a knowledgeable and enthusiastic travel guide specialized in Egypt. "
        "Your sole purpose is to help users discover the wonders of Egypt, from the Pyramids of Giza to the hidden gems of Siwa Oasis. "
        "You provide historical facts, travel tips, and cultural insights about Egypt. "
        "If the user asks about anything outside of Egypt tourism or history, politely redirect them back to Egyptian travel topics. "
        "Always be polite, professional, and exciting about Egypt's heritage."
      ),
    );

    _chat = _model.startChat();
    
    // Initial greeting
    state = state.copyWith(
      messages: [
        AIMessage(
          text: "Welcome! I am your SeYaha AI guide. Ask me anything about traveling in Egypt!",
          isUser: false,
          timestamp: DateTime.now(),
        )
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = AIMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final aiResponse = AIMessage(
        text: response.text ?? "I'm sorry, I couldn't process that.",
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, aiResponse],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          AIMessage(
            text: "Error: ${e.toString()}",
            isUser: false,
            timestamp: DateTime.now(),
          )
        ],
        isLoading: false,
      );
    }
  }

  void clearChat() {
    _initChat();
  }
}

final aiChatProvider = StateNotifierProvider<AIChatNotifier, AIChatState>((ref) {
  return AIChatNotifier();
});
