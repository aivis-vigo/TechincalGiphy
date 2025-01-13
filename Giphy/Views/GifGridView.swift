//
//  ContentView.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 08/01/2025.
//

import SwiftUI

struct GifGridView: View {
    // @StateObject - instantiates observable object
    @StateObject var gifViewModel = GifViewModel()
    @State var selectedImage: Gif?
    @State var searchPrompt: String = ""
    
    // todo: layout
    // todo: different color scheme
    // todo: different font (also for editor???)
    // todo: vertical and horizontal layout support
     
    var body: some View {
        NavigationStack {
            Grid {
                ScrollView {
                    /*
                        creating items only when they are needed
                    */
                    LazyVStack {
                        /*
                            .enumarted creates value pairs like (id, gif) where the id is the
                            index used to determine when to load more images while scrolling
                        */
                        ForEach(Array(gifViewModel.trendingCollection.enumerated()), id: \.offset) { index, gif in
                            NavigationLink(destination: GifDetailsView(gif: $selectedImage)) {
                                GridRow {
                                    GifImageLoader(gif.images.original.url)
                                }
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                selectedImage = gif
                            })
                            .task {
                                /*
                                    when last image is about to be reached this executes code to fetch more images
                                */
                                guard let lastImage = gifViewModel.trendingCollection.last else {return}
                                if gifViewModel.trendingCollection[index].id == lastImage.id {
                                    Task {
                                        await gifViewModel.fetchTrendingImages()
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Trending")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchPrompt, prompt: "Search...")
                /*
                    every single time value of 'searchPrompt' changes the updateSearch function is executed
                 
                    '_' ignores the first param which is the old value (usually used to track how value has changed?)
                */
                .onChange(of: searchPrompt) { _, newValue in
                    gifViewModel.updateSearch(userSearchInput: newValue)
                }
                /*
                    load first 50 images before the view appears
                */
                .task {
                    Task {
                        await gifViewModel.fetchTrendingImages()
                    }
                }
            }
        }
    }
}

#Preview {
    GifGridView()
}
