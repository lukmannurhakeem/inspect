import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';

Future<(Uint8List?, String?)> pickImageFromCamera() async {
  return _pickImageWithInput(capture: true);
}

Future<(Uint8List?, String?)> pickImageFromGallery() async {
  return _pickImageWithInput(capture: false);
}

Future<(Uint8List?, String?)> _pickImageWithInput({
  required bool capture,
}) async {
  final completer = Completer<(Uint8List?, String?)>();

  final input =
      html.FileUploadInputElement()
        ..accept = 'image/*'
        ..style.display = 'none';

  if (capture) {
    input.setAttribute('capture', 'environment'); // use 'user' for front camera
  }

  html.document.body?.append(input);

  input.onChange.listen((event) async {
    final files = input.files;
    if (files != null && files.isNotEmpty) {
      final file = files.first;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;
      final bytes = reader.result as Uint8List;
      completer.complete((bytes, file.name));
    } else {
      completer.complete((null, null));
    }
    input.remove();
  });

  input.onAbort.listen((_) {
    completer.complete((null, null));
    input.remove();
  });

  input.click();

  return completer.future;
}
