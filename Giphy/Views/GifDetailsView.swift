//
//  GifDetailsView.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 09/01/2025.
//

import SwiftUI

struct GifDetailsView: View {
    @Binding var gif: Gif?
    
    var body: some View {
        NavigationStack {
            GifImageLoader(gif?.images.original.url ?? "")
            Text("Title: \(gif?.title ?? "-")")
                .navigationTitle("Details")
            Text("Rating: \(gif?.rating ?? "-")")
            Text("Author: \(gif?.username ?? "-")")
            Text("Date: \(gif?.importDatetime ?? "-")")
        }
    }
}
