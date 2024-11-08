// File: lib/pdf_helper.dart

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

export 'pdf_helper_stub.dart' if (dart.library.js_util) 'pdf_helper.dart';

// Binds to the JavaScript extractTextFromPDF function
@JS('extractTextFromPDF')
external dynamic _extractTextFromPDF(Uint8List arrayBuffer);

class PdfHelper {
  // Default implementation
  static Future<String> extractTextFromPDF(
    Uint8List arrayBuffer,
  ) async {
    final result =
        await promiseToFuture<String>(_extractTextFromPDF(arrayBuffer));

    return result;
  }

  static Future<Uint8List> selectPdf() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // Ensure bytes are available
    );

    if (result != null && result.files.single.bytes != null) {
      return result.files.single.bytes!;
    } else {
      // Throw a descriptive exception
      throw 'No PDF file selected';
    }
  }
}
