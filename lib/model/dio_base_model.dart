import 'package:dio/dio.dart';

class DioBaseModel<T> {
  final T? model;
  final Response? response;

  DioBaseModel({this.model, this.response});

  DioBaseModel<T> copyWith({
    T? model,
    Response? response,
  }) {
    return DioBaseModel<T>(
      model: model ?? this.model,
      response: response ?? this.response,
    );
  }

  @override
  String toString() => 'DioBaseModel(model: $model, response: $response)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DioBaseModel<T> && other.model == model && other.response == response;
  }

  @override
  int get hashCode => model.hashCode ^ response.hashCode;
}
