//
//  FullscreenView2.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 23.09.24.
//

import SwiftUI

struct FullscreenView: View {
    let imageUrl: URL
    
    var body: some View {
        VStack {
            AsyncImage(url: imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)
            } placeholder: {
                ProgressView()
            }
        }
    }
}
