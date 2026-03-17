import 'package:backend/handlers/auth_handler.dart';
import 'package:backend/utils/app_response.dart';
import 'package:common/utils/response_body.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return AppResponse.badRequest(
      const ResponseBody(success: false, message: 'Method not allowed'),
    );
  }

  final authHandler = context.read<AuthHandler>();
  return authHandler.handleRefresh(context.request);
}
