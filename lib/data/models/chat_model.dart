import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(name: '_id') required String id,
    required String booking,
    required String content,
    required User sender,
    DateTime? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
