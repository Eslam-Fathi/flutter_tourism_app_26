import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class Company with _$Company {
  const factory Company({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String category,
    @Default(false) bool approved,
    String? description,
    String? address,
    String? phone,
    String? logo,
    @JsonKey(fromJson: _parseOwner) String? owner,
    DateTime? createdAt,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}

String? _parseOwner(dynamic owner) {
  if (owner == null) return null;
  if (owner is String) return owner;
  if (owner is Map) return owner['_id']?.toString() ?? owner['id']?.toString();
  return null;
}
