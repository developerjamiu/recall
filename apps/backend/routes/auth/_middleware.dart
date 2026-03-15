import 'package:backend/middleware/rate_limiter.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(rateLimiter());
}
