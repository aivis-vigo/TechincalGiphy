//
//  Images.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 15/01/2025.
//

import Foundation

struct Images: Codable {
    let original: Original
}

struct Original: Codable {
    let url: String
    let height: String
    let width: String
}
