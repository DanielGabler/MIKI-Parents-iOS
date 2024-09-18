//
//  FileDetailView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 18.09.24.
//

import SwiftUI
import WebKit

struct FileDetailView: View {
    let file: FileItem
    
    var body: some View {
        VStack {
            if file.type == "image" {
                // Bildanzeige im Vollbildmodus
                AsyncImage(url: URL(string: file.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ProgressView()
                    }
                }
            } else if file.type == "document" {
                // Dokumentanzeige im WebView
                if let url = URL(string: file.imageUrl) {
                    DocumentWebView(url: url)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle(file.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// WebView für die Anzeige von Dokumenten
struct DocumentWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
