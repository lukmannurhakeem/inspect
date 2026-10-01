// Web-only window helpers
import 'dart:html' as html;
import 'dart:typed_data';

void openInNewTab(String url) {
  html.window.open(url, '_blank');
}

void downloadBlob(List<int> bytes, String mimeType, String fileName) {
  final blob = html.Blob([Uint8List.fromList(bytes)], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor =
      html.AnchorElement(href: url)
        ..download = fileName
        ..style.display = 'none';
  html.document.body?.append(anchor);
  anchor.click();
  Future.delayed(const Duration(milliseconds: 100), () {
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  });
}
