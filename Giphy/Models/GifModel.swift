//
//  GifModel.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 08/01/2025.
//

import Foundation

struct Gifs: Codable {
    let data: [Gif]
}

struct Gif: Identifiable, Codable {
    let id: String
    let title: String
    let username: String
    let importDatetime: String
    let rating: String
    let images: Images
}
