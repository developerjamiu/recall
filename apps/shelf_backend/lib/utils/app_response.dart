import 'package:common/utils/response_body.dart';
import 'package:shelf/shelf.dart';

class AppResponse {
  static Response json(
    ResponseBody body, {
    required int statusCode,
    Map<String, Object>? headers,
  }) {
    return Response(
      statusCode,
      body: body.toJson(),
      headers: {
        'content-type': 'application/json',
        ...?headers,
      },
    );
  }

  static Response ok(ResponseBody body, {Map<String, Object>? headers}) =>
      json(body, statusCode: 200, headers: headers);

  static Response created(ResponseBody body, {Map<String, Object>? headers}) =>
      json(body, statusCode: 201, headers: headers);

  static Response found({required Uri redirectUri}) => Response(
        302,
        headers: {'location': redirectUri.toString()},
      );

  static Response badRequest(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 400, headers: headers);

  static Response unauthorized(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 401, headers: headers);

  static Response notFound(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 404, headers: headers);

  static Response forbidden(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 403, headers: headers);

  static Response tooManyRequests(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 429, headers: headers);

  static Response unprocessableEntity(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 422, headers: headers);

  static Response noContent({Map<String, Object>? headers}) => Response(
        204,
        headers: headers,
      );

  static Response internalServerError(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, statusCode: 500, headers: headers);
}
