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
    @State private var qrCodeImage: UIImage? = nil
    @Environment(\.dismiss) private var dismiss // Zugriff auf die Dismiss-Umgebung

    init() {
        _qrCodeImage = State(initialValue: generateUserQRCode())
    }

    var body: some View {
        VStack {
            // Hinweistext oberhalb des QR-Codes
            Text("Teile diesen QR Code deinem Familienmitglied mit, damit er beim Login verwendet werden kann um der Familie beizutreten.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 200, height: 200)
                    .padding()
                
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
        .navigationBarBackButtonHidden(true) // Standard-Zurück-Button verstecken
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Zurück") {
                    dismiss() // Zurück zur vorherigen Ansicht
                }
                .foregroundColor(.blue)
            }
        }
    }

    func generateUserQRCode() -> UIImage? {
        guard let user = Auth.auth().currentUser else {
            print("Benutzer ist nicht authentifiziert.")
            return nil
        }
        // Nur die E-Mail-Adresse in den QR-Code aufnehmen
        let loginInfo = "email: \(user.email ?? "")"
        return generateQRCode(from: loginInfo)
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        if let outputImage = filter.outputImage?.transformed(by: transform) {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }

    func shareQRCode(_ qrCode: UIImage?) {
        guard let qrCode = qrCode else { return }
        let activityVC = UIActivityViewController(activityItems: [qrCode], applicationActivities: nil)
        
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
