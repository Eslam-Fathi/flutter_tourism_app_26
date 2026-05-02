import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required bool success,
    required String token,
    @JsonKey(name: 'data') User? user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String name,
    required String email,
    required String password,
    @Default('user') String role,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
}
