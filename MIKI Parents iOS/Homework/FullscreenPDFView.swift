//
//  FullscreenPDFView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 23.09.24.
//

import PDFKit
import SwiftUI

struct FullscreenPDFView: View {
    let pdfUrl: URL

    var body: some View {
        PDFKitView(url: pdfUrl)
            .edgesIgnoringSafeArea(.all) // Zeige das PDF im Vollbildmodus an
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let document = PDFDocument(url: url) {
            pdfView.document = document
            pdfView.autoScales = true
        }
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Keine Aktualisierung erforderlich
    }
}
