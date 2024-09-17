//
//  Page2View.swift
//  MIKI Parents iOS
//
//  Created by Daniel Gabler on 10.09.24.
//

import SwiftUI

struct NotesTabView: View {
    @StateObject private var viewModel = NotesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if viewModel.items.isEmpty {
                    Text("No data available")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.items) { item in
                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Firestore Items")
            .onAppear {
                viewModel.fetchItems()
            }
        }
    }
}

#Preview {
    NotesTabView()
}
