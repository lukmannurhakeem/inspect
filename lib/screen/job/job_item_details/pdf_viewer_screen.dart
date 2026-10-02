import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:inspect/core/utils/web_window_helper.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final Uint8List pdfData;
  final String reportName;

  const PdfViewerScreen({
    Key? key,
    required this.pdfData,
    this.reportName = 'Report',
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfControllerPinch _pdfController;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(widget.pdfData),
      );
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) _pdfController.dispose();
    super.dispose();
  }

  void _downloadPdf() {
    downloadBlob(widget.pdfData, 'application/pdf', '${widget.reportName}.pdf');
  }

  @override
  Widget build(BuildContext context) {
    // On web: show a simple download/open button
    // (we can't embed a PDF viewer inline on Flutter web easily)
    if (kIsWeb) {
      final url =
          Uri.dataFromBytes(
            widget.pdfData,
            mimeType: 'application/pdf',
          ).toString();

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.reportName),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Download PDF',
              onPressed: _downloadPdf,
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                widget.reportName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => openInNewTab(url),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open PDF'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _downloadPdf,
                icon: const Icon(Icons.download),
                label: const Text('Download PDF'),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile: use pdfx viewer
    return Scaffold(
      appBar: AppBar(title: Text(widget.reportName)),
      body: PdfViewPinch(controller: _pdfController),
    );
  }
}
