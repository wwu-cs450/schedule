import 'package:flutter/material.dart';

class ImportPDFPage extends StatefulWidget {
  const ImportPDFPage({super.key});

  @override
  ImportPDFPageState createState() => ImportPDFPageState();
}

class ImportPDFPageState extends State<ImportPDFPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Import PDF',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder icon and text
            const Icon(
              Icons.picture_as_pdf,
              color: Colors.deepPurple,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a PDF to View',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Browse your device to import a PDF file and preview it here.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Placeholder for the Select PDF button
            ElevatedButton.icon(
              onPressed: () {
                // Placeholder functionality
              },
              icon: const Icon(Icons.file_open, color: Colors.white),
              label: const Text(
                'Select PDF',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Placeholder for the PDF preview box
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color.fromRGBO(
                    103,
                    58,
                    183,
                    0.2,
                  ), // 20% opacity for deepPurple
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  'PDF Preview Will Appear Here',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
