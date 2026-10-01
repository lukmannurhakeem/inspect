// Conditional import: uses dart:html on web, stub on mobile/desktop.
export 'camera_web_helper_stub.dart'
    if (dart.library.html) 'camera_web_helper_web.dart';
