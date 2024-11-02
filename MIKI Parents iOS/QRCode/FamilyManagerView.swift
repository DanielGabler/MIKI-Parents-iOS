//
//  FamilyManagerView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 17.10.24.
//


import SwiftUI
import AVFoundation
import CoreImage.CIFilterBuiltins
import FirebaseAuth

struct FamilyManagerView: View {
    @State private var isShowingScanner = false
    @State private var qrCodeImage: UIImage? = nil
    @State private var scannedCode: String = ""
    
    init() {
        // Initialisieren und generieren des QR-Codes beim Laden der View
        _qrCodeImage = State(initialValue: generateUserQRCode())
    }

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

            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none) // Verhindert das Weichzeichnen beim Skalieren
                    .frame(width: 200, height: 200)
                    .padding()
                
                // Button zum Teilen des QR-Codes
                Button("QR Code teilen") {
                    shareQRCode(qrCodeImage)
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .navigationTitle("Family Manager")
    }

    // Funktion zur Generierung des QR-Codes mit E-Mail und Passwort
    func generateUserQRCode() -> UIImage? {
        guard let user = Auth.auth().currentUser else {
            print("Benutzer ist nicht authentifiziert.")
            return nil
        }
        
        // Beispiel: Passwort sollte sicher gespeichert werden; hier als Platzhalter verwendet
        let password = "userPasswordPlaceholder" // Platzhalter für das Passwort

        // Format der Anmeldedaten für den QR-Code
        let loginInfo = "email: \(user.email ?? ""), password: \(password)"
        return generateQRCode(from: loginInfo)
    }

    // QR-Code aus einem String generieren
    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10) // QR-Code um das 10-fache vergrößern

        if let outputImage = filter.outputImage?.transformed(by: transform) {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }

    // Funktion zum Teilen des QR-Codes
    func shareQRCode(_ qrCode: UIImage?) {
        guard let qrCode = qrCode else { return }
        let activityVC = UIActivityViewController(activityItems: [qrCode], applicationActivities: nil)
        
        // Auf dem Hauptthread ausführen
        DispatchQueue.main.async {
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(activityVC, animated: true, completion: nil)
            }
        }
    }
}

#Preview {
    FamilyManagerView()
}
