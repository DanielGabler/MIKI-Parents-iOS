//
//  PDFThumbnailView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 23.09.24.
//

import PDFKit
import SwiftUI

struct PDFThumbnailView: View {
    let url: URL

    var body: some View {
        if let pdfDocument = PDFDocument(url: url), let page = pdfDocument.page(at: 0) {
            PDFPageView(page: page)
        } else {
            Color.gray // Platzhalter falls PDF nicht geladen werden kann
        }
    }
}

struct PDFPageView: View {
    let page: PDFPage

    var body: some View {
        GeometryReader { geometry in
            let pdfImage = page.thumbnail(of: geometry.size, for: .mediaBox)
            Image(uiImage: pdfImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}
