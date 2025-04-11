#! python

from pypdf import PdfReader

pdf_path = (
    "/Users/jfoster/Library/CloudStorage/"
    "OneDrive-WallaWallaUniversity/Bulletins/"
    "2024-2025 Undergraduate-Bulletin (unlocked).pdf"
)
reader = PdfReader(pdf_path)
with open("bulletin.txt", "w") as f:
    for page in reader.pages:
        f.write(page.extract_text())
        f.write("\n")
