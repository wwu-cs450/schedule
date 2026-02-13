import 'package:web/web.dart' as web;

/// Returns the appropriate API host URL based on whether we are in development or production.
String host() {
  return web.window.location.hostname == 'schedule.cs.wallawalla.edu'
      ? 'https://schedule.cs.wallawalla.edu'
      : 'http://localhost:8080';
}
