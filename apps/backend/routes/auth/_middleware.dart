import 'package:backend/middleware/rate_limiter.dart';
import 'package:dart_frog/dart_frog.dart';

// Initialised once so the in-memory bucket persists across requests
final _rateLimiter = rateLimiter();

Handler middleware(Handler handler) {
  return handler.use(_rateLimiter);
}
