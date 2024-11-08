// File: web/js/pdf_helper.js

// Set the workerSrc to point to the location of pdf.worker.js
pdfjsLib.GlobalWorkerOptions.workerSrc = 'js/pdf.worker.js';

async function extractTextFromPDF(arrayBuffer) {
  try {
    // Load the PDF document from the ArrayBuffer
    const loadingTask = pdfjsLib.getDocument({ data: arrayBuffer });
    const pdf = await loadingTask.promise;
    let fullText = '';

    // Iterate through each page
    for (let pageNum = 1; pageNum <= pdf.numPages; pageNum++) {
      const page = await pdf.getPage(pageNum);
      const content = await page.getTextContent();
      const strings = content.items.map(item => item.str);
      fullText += strings.join(' ') + '\n';
    }

    return fullText;
  } catch (error) {
    console.error('Error extracting text from PDF:', error);
    throw error;
  }
}

// Expose the function to Dart via the global window object
window.pdfHelper = {
  extractTextFromPDF: extractTextFromPDF
};