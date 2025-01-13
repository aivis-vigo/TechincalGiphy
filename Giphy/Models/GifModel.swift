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

struct Images: Codable {
    let original: Original
}

struct Original: Codable {
    let url: String
    let height: String
    let width: String
}

enum GifError: Error {
     case invalidURL
     case invalidResponse
     case invalidData
}
