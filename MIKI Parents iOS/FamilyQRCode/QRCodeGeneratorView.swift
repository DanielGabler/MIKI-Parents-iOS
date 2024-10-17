//
//  QRCodeGeneratorView.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 15.10.24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGeneratorView: View {
    let familyId: String
    
    var body: some View {
        VStack {
            if let qrCodeImage = generateQRCode(from: familyId) {
                Image(uiImage: qrCodeImage)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            } else {
                Text("QR Code konnte nicht generiert werden.")
            }
        }
    }
    
    // QR-Code-Generierungsfunktion
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            return UIImage(ciImage: scaledImage)
        }
        return nil
    }
}

#Preview {
    QRCodeGeneratorView(familyId: "example-family-id")
}
