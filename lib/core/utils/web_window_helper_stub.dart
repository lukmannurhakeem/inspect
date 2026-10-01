// Stub for non-web platforms
void openInNewTab(String url) {
  // No-op on mobile; callers should use url_launcher instead
}

void downloadBlob(List<int> bytes, String mimeType, String fileName) {
  // No-op on mobile
}
