// Stub for non-web platforms
import 'dart:typed_data';

void openInNewTab(String url) {
  // No-op on mobile; callers should use url_launcher instead
}

void openPdfBytesInNewTab(Uint8List bytes) {
  // No-op on mobile
}

void downloadBlob(List<int> bytes, String mimeType, String fileName) {
  // No-op on mobile
}