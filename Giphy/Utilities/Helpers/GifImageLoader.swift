//
//  GifImage.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 09/01/2025.
//

import Foundation
import SwiftUI
import SwiftyGif

struct GifImageLoader: UIViewRepresentable {
    private let url: String
    
    init (_ url: String) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(gifURL: URL(string: url)!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.setGifFromURL(URL(string: url)!)
    }
}
