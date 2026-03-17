import 'dart:collection';

import 'package:backend/utils/app_response.dart';
import 'package:common/utils/response_body.dart';
import 'package:dart_frog/dart_frog.dart';

/// In-memory rate limiter middleware.
///
/// Limits requests per IP to [maxRequests] within [window].
Middleware rateLimiter({
  int maxRequests = 10,
  Duration window = const Duration(minutes: 1),
}) {
  final buckets = HashMap<String, _TokenBucket>();
  var lastCleanup = DateTime.now().toUtc();
  const cleanupInterval = Duration(minutes: 5);

  return (handler) {
    return (context) {
      final ip =
          context.request.headers['x-forwarded-for']?.split(',').first.trim() ??
          context.request.connectionInfo.remoteAddress.address;

      final now = DateTime.now().toUtc();

      // Periodically remove stale buckets to prevent unbounded growth
      if (now.difference(lastCleanup) > cleanupInterval) {
        buckets.removeWhere(
          (_, b) => b.timestamps.isEmpty ||
              now.difference(b.timestamps.last) > window,
        );
        lastCleanup = now;
      }

      final bucket = buckets.putIfAbsent(ip, _TokenBucket.new);

      // Remove expired entries
      bucket.timestamps.removeWhere(
        (t) => now.difference(t) > window,
      );

      if (bucket.timestamps.length >= maxRequests) {
        final oldestValid = bucket.timestamps.first;
        final retryAfter = window - now.difference(oldestValid);

        return AppResponse.tooManyRequests(
          const ResponseBody(
            success: false,
            message: 'Too many requests. Try again later.',
          ),
          headers: {'retry-after': retryAfter.inSeconds.toString()},
        );
      }

      bucket.timestamps.add(now);
      return handler(context);
    };
  };
}

class _TokenBucket {
  final timestamps = Queue<DateTime>();
}
