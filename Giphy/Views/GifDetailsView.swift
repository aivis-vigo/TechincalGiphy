//
//  GifDetailsView.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 09/01/2025.
//

import SwiftUI

struct GifDetailsView: View {
    @StateObject var parentViewModel: GifViewModel    
    @Binding var gif: Gif?

    @Environment(\.verticalSizeClass) var heightlSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        ScrollView {
            NavigationStack {
                if heightlSizeClass == .regular {
                    GifImageLoader(gif?.images.original.url ?? "")
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                    Text("Title: \(gif?.title ?? "-")")
                        .navigationTitle("Details")
                    Text("Rating: \(gif?.rating ?? "-")")
                    Text("Author: \(gif?.username ?? "-")")
                    Text("Date: \(gif?.importDatetime ?? "-")")
                } else {
                    Grid {
                        GridRow {
                            GifImageLoader(gif?.images.original.url ?? "")
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Title: \(gif?.title ?? "-")")
                                    .navigationTitle("Details")
                                Text("Rating: \(gif?.rating ?? "-")")
                                Text("Author: \(gif?.username ?? "-")")
                                Text("Date: \(gif?.importDatetime ?? "-")")
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .alert(isPresented: $parentViewModel.showError, withError: parentViewModel.imageError)
    }
}
