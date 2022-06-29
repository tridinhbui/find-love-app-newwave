
import 'package:json_annotation/json_annotation.dart';
part 'object_response.g.dart';
@JsonSerializable(genericArgumentFactories: true)
class ObjectResponse<T>{
  @JsonKey(defaultValue: false)
  final bool? success;
  @JsonKey(defaultValue: 0)
  final int? code;
  @JsonKey(defaultValue: "en")
  final String? locale;
  @JsonKey(defaultValue: '')
  final String? message;
  @JsonKey(defaultValue: '')
  final String? returnCode;
  @JsonKey()
  final T? data;

  ObjectResponse({
    this.success,
    this.code,
    this.locale,
    this.message,
    this.returnCode,
    this.data,
  });

  factory ObjectResponse.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ObjectResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ObjectResponseToJson(this, toJsonT);
}
