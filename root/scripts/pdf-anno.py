#!/root/anaconda3/bin/python3
import sys

from pdfminer.converter import PDFPageAggregator
from pdfminer.layout import LAParams
from pdfminer.pdfdocument import PDFDocument
from pdfminer.pdfinterp import PDFPageInterpreter, PDFResourceManager
from pdfminer.pdfpage import PDFPage
from pdfminer.pdfparser import PDFParser
from pdfminer.pdftypes import PDFObjRef


def extract_annotations(pdf_path, txt_path):
    with open(pdf_path, 'rb') as f:
        parser = PDFParser(f)
        doc = PDFDocument(parser)
        rsrcmgr = PDFResourceManager()
        device = PDFPageAggregator(rsrcmgr, laparams=LAParams())
        interpreter = PDFPageInterpreter(rsrcmgr, device)

        annotations = []
        for page in PDFPage.create_pages(doc):
            interpreter.process_page(page)
#             layout = device.get_result()

            if page.annots:
                annot: PDFObjRef
                for annot in page.annots:
                    resolve = annot.resolve()
                    if 'Contents' in resolve:
                        annotations.append(
                            resolve['Contents'].decode('utf-16be'))

        print(f"Found {len(annotations)} annotations")
        with open(txt_path, 'w') as f:
            for annotation in annotations:
                f.write(annotation + "\n")


if __name__ == '__main__':
    if len(sys.argv) >= 2:
        pdf_path = sys.argv[1]
        assert pdf_path.endswith(".pdf")
        if len(sys.argv) >= 3:
            txt_path = sys.argv[2]
        else:
            txt_path = pdf_path[:-4] + ".txt"
        extract_annotations(pdf_path, txt_path)
    else:
        print("Usage: python pdf-anno.py <pdf_path> [txt_path]")
