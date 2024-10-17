//
//  FamilyManagerView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 17.10.24.
//


import SwiftUI
import AVFoundation
import CoreImage.CIFilterBuiltins

struct FamilyManagerView: View {
    @State private var isShowingScanner = false
    @State private var qrCodeImage: UIImage? = nil
    @State private var scannedCode: String = ""

    var body: some View {
        VStack {
            
            
            // QR-Code Scanner Button
            Button("QR Code scannen") {
                isShowingScanner = true // Scanner anzeigen
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .sheet(isPresented: $isShowingScanner) {
                QRCodeScannerView(scannedCode: $scannedCode)
            }

            if !scannedCode.isEmpty {
                Text("Gescanntes Ergebnis: \(scannedCode)")
                    .padding()
            }
            
            // QR-Code Generierung Button
            Button("QR Code generieren") {
                let familyID = "123456" // Beispiel: Die Familie-ID oder andere Informationen
                qrCodeImage = generateQRCode(from: familyID)
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
        }
        .navigationTitle("Family Manager")
    }

    // Funktion zum Generieren eines QR-Codes aus einem String
    func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.setValue(Data(string.utf8), forKey: "inputMessage")

        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }
}

#Preview {
    FamilyManagerView()
}
