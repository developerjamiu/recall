import 'package:common/utils/response_body.dart';
import 'package:dart_frog/dart_frog.dart';

class AppResponse {
  static Response json(
    ResponseBody body, {
    required HttpStatus status,
    Map<String, Object>? headers,
  }) {
    final jsonHeaders = <String, Object>{
      'content-type': 'application/json',
      ...?headers,
    };

    return Response(
      statusCode: status.code,
      body: body.toJson(),
      headers: jsonHeaders,
    );
  }

  static Response ok(ResponseBody body, {Map<String, Object>? headers}) =>
      json(body, status: HttpStatus.ok, headers: headers);

  static Response created(ResponseBody body, {Map<String, Object>? headers}) =>
      json(body, status: HttpStatus.created, headers: headers);

  static Response noContent({Map<String, Object>? headers}) =>
      Response(statusCode: HttpStatus.noContent.code, headers: headers);

  static Response found({required Uri redirectUri}) => Response.json(
        statusCode: HttpStatus.found.code,
        headers: {'location': redirectUri.toString()},
      );

  static Response badRequest(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, status: HttpStatus.badRequest, headers: headers);

  static Response unauthorized(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, status: HttpStatus.unauthorized, headers: headers);

  static Response forbidden(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, status: HttpStatus.forbidden, headers: headers);

  static Response notFound(ResponseBody body, {Map<String, Object>? headers}) =>
      json(body, status: HttpStatus.notFound, headers: headers);

  static Response unprocessableEntity(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, status: HttpStatus.unprocessableEntity, headers: headers);

  static Response tooManyRequests(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, status: HttpStatus.tooManyRequests, headers: headers);

  static Response internalServerError(
    ResponseBody body, {
    Map<String, Object>? headers,
  }) =>
      json(body, status: HttpStatus.internalServerError, headers: headers);
}

enum HttpStatus {
  ok(200),
  created(201),
  noContent(204),
  found(302),
  badRequest(400),
  unauthorized(401),
  forbidden(403),
  notFound(404),
  unprocessableEntity(422),
  tooManyRequests(429),
  internalServerError(500);

  const HttpStatus(this.code);
  final int code;
}
