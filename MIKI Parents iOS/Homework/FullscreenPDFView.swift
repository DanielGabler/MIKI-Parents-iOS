//
//  FullscreenPDFView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 23.09.24.
//

import PDFKit
import SwiftUI
import FirebaseCore

struct FullscreenPDFView: View {
    let pdfUrl: URL
    let uploadDate: Timestamp?
    
    var body: some View {
        VStack {
            PDFKitView(url: pdfUrl)
                .edgesIgnoringSafeArea(.all)

            if let date = uploadDate?.dateValue() {
                Text("Uploaded on: \(date, formatter: dateFormatter)")
                    .padding()
            }
        }
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
