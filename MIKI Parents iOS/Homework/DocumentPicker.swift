//
//  DocumentPicker.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 18.09.24.
//

import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedDocument: URL? // Speichert die URL des ausgewählten Dokuments

    class Coordinator: NSObject, UINavigationControllerDelegate, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        // Called when a document is picked
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedUrl = urls.first else { return }
            parent.selectedDocument = selectedUrl // Set the selected document URL
            parent.presentationMode.wrappedValue.dismiss() // Dismiss picker
        }

        // Called when the user cancels the picker
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss() // Dismiss picker
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .plainText, .image]) // Allow PDFs, text, and images
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {}
}
