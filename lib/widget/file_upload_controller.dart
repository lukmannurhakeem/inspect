import 'dart:io';
import 'dart:typed_data';
import 'package:inspect/core/utils/camera_web_helper.dart'
    if (dart.library.html) 'package:inspect/core/utils/camera_web_helper_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect/core/extension/theme_extension.dart';

class FileUploadController extends ChangeNotifier {
  static const _imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
  ];

  PlatformFile? _pickedFile;
  File? _imageFile;

  PlatformFile? get pickedFile => _pickedFile;

  File? get imageFile => _imageFile;

  bool get hasFile => _pickedFile != null || _imageFile != null;

  String get fileName {
    if (_pickedFile != null) return _pickedFile!.name;
    if (_imageFile != null) return _imageFile!.path.split('/').last;
    return '';
  }

  bool get isImage {
    final name = fileName.toLowerCase();
    return _imageExtensions.any(name.endsWith);
  }

  int? get fileSize {
    if (_pickedFile != null) return _pickedFile!.size;
    if (_imageFile == null) return null;
    try {
      return _imageFile!.lengthSync();
    } catch (_) {
      return null;
    }
  }

  void _update({PlatformFile? picked, File? image}) {
    _pickedFile = picked;
    _imageFile = image;
    notifyListeners();
  }

  void setFile(PlatformFile? file) => _update(picked: file);

  void setImageFile(File? file) => _update(image: file);

  void setWebImage(Uint8List? bytes, String? name) => _update(
    picked: bytes == null
        ? null
        : PlatformFile(
            name: name ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
            size: bytes.length,
            bytes: bytes,
          ),
  );

  void clear() => _update();
}

class CommonFileUploadInput extends StatefulWidget {
  final FileUploadController controller;
  final String? label;
  final List<String>? allowedExtensions;
  final bool isRequired;
  final bool enableCamera;

  const CommonFileUploadInput({
    super.key,
    required this.controller,
    this.label,
    this.allowedExtensions,
    this.isRequired = false,
    this.enableCamera = false,
  });

  @override
  State<CommonFileUploadInput> createState() => _CommonFileUploadInputState();
}

class _CommonFileUploadInputState extends State<CommonFileUploadInput> {
  final ImagePicker _imagePicker = ImagePicker();

  FileUploadController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void didUpdateWidget(covariant CommonFileUploadInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerUpdate);
      widget.controller.addListener(_onControllerUpdate);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: widget.allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: widget.allowedExtensions,
      withData: true,
    );
    if (result != null) _controller.setFile(result.files.first);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (kIsWeb) {
      final (bytes, name) = source == ImageSource.camera
          ? await pickImageFromCamera()
          : await pickImageFromGallery();
      if (bytes != null) _controller.setWebImage(bytes, name);
      return;
    }

    final photo = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (photo != null) _controller.setImageFile(File(photo.path));
  }

  void _showPickerOptions() {
    final options = [
      (
        Icons.photo_library,
        'Choose from Gallery',
        () => _pickPhoto(ImageSource.gallery),
      ),
      (Icons.camera_alt, 'Take Photo', () => _pickPhoto(ImageSource.camera)),
      (Icons.insert_drive_file, 'Choose File', _pickFile),
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (icon, title, action) in options)
                ListTile(
                  leading: Icon(icon, color: context.colors.primary),
                  title: Text(title),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    action();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget? _buildImagePreview() {
    final image = _controller.imageFile;
    if (image != null && !kIsWeb) {
      return Image.file(image, width: double.infinity, fit: BoxFit.contain);
    }

    final picked = _controller.pickedFile;
    if (picked == null || !_controller.isImage) return null;

    final bytes = picked.bytes;
    if (bytes != null) {
      return Image.memory(bytes, width: double.infinity, fit: BoxFit.contain);
    }

    final path = picked.path;
    if (!kIsWeb && path != null) {
      return Image.file(
        File(path),
        width: double.infinity,
        fit: BoxFit.contain,
      );
    }
    return null;
  }

  Widget _buildPickButton() {
    final primary = context.colors.primary;

    return ElevatedButton.icon(
      onPressed: widget.enableCamera ? _showPickerOptions : _pickFile,
      icon: Icon(
        widget.enableCamera ? Icons.add_photo_alternate : Icons.upload_file,
        color: primary,
      ),
      label: Text(
        widget.enableCamera ? 'Add File/Photo' : 'Choose File',
        style: context.topology.textTheme.titleSmall?.copyWith(color: primary),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildFileInfo(Widget? preview) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;
    final size = _controller.fileSize;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                preview != null
                    ? Icons.image_outlined
                    : Icons.insert_drive_file_outlined,
                color: primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _controller.fileName,
                  style: textTheme.bodyMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (size != null) ...[
                const SizedBox(width: 8),
                Text(
                  _formatFileSize(size),
                  style: textTheme.bodySmall?.copyWith(
                    color: primary.withOpacity(0.55),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
          if (preview != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: preview,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.isRequired ? '$label *' : label,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        Row(
          children: [
            _buildPickButton(),
            if (_controller.hasFile) ...[
              const SizedBox(width: 12),
              IconButton(
                onPressed: _controller.clear,
                icon: const Icon(Icons.close, color: Colors.red),
                tooltip: 'Remove file',
              ),
            ],
          ],
        ),
        if (_controller.hasFile) ...[
          const SizedBox(height: 12),
          _buildFileInfo(_buildImagePreview()),
        ],
      ],
    );
  }
}
