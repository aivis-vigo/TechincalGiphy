//
//  TrendingView.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 14/01/2025.
//

import SwiftUI

struct TrendingView: View {
    // @StateObject - instantiates observable object
    @StateObject var gifViewModel = GifViewModel()
    @State var selectedImage: Gif?
    
    @Environment(\.verticalSizeClass) var heightlSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        DynamicGrid {
            ForEach(Array(gifViewModel.trendingResults.enumerated()), id: \.offset) { index, gif in
                NavigationLink(destination: GifDetailsView(parentViewModel: gifViewModel, gif: $selectedImage)) {
                    GridRow {
                        GifImageLoader(gif.images.original.url)
                            .frame(maxWidth: .infinity)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded {
                    selectedImage = gif
                })
                .task {
                    /*
                        when last image is about to be reached this executes code to fetch more images
                    */
                    guard let lastImage = gifViewModel.trendingResults.last else {return}
                    if gifViewModel.trendingResults[index].id == lastImage.id {
                        Task {
                            await gifViewModel.fetchTrendingImages()
                        }
                    }
                }
            }
        }
        .task {
            Task {
                await gifViewModel.fetchTrendingImages()
            }
        }
        .alert(isPresented: $gifViewModel.showError, withError: gifViewModel.imageError)
    }
}
