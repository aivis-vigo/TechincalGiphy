//
//  SearchView.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 14/01/2025.
//

import SwiftUI

struct SearchView: View {
    // @StateObject - instantiates observable object
    @StateObject var gifViewModel = GifViewModel()
    @State var selectedImage: Gif?
    @State var searchPrompt: String = ""
    
    @Environment(\.verticalSizeClass) var heightlSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    
    var body: some View {        
        DynamicGrid {
            ForEach(Array(gifViewModel.searchResults.enumerated()), id: \.offset) { index, gif in
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
                    guard let lastImage = gifViewModel.searchResults.last else {return}
                    if gifViewModel.searchResults[index].id == lastImage.id {
                        Task {
                            await gifViewModel.fetchBySearchQuery(searchInput: searchPrompt)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchPrompt)
        /*
            every single time value of 'searchPrompt' changes the updateSearch function is executed

            '_' ignores the first param which is the old value (usually used to track how value has changed?)
        */
        .onChange(of: searchPrompt) { _, newValue in
            gifViewModel.updateSearch(userSearchInput: newValue)
        }
        .alert(isPresented: $gifViewModel.showError, withError: gifViewModel.imageError)
    }
}
