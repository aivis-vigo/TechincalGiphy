//
//  MockImageService.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 16/01/2025.
//

import Foundation

class MockImageService: ImageServiceProtocol {
    func fetchTrendingImages() async throws -> [Gif] {
        let jsonString = """
            {
                "data": [
                    {
                        "id": "sample123",
                        "url": "https://giphy.com/sample123",
                        "title": "Sample Gif"
                    }
                ]
            }
        """
        
        guard let data = jsonString.data(using: .utf8) else {
            throw GifError.invalidData
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gifsResponse = try decoder.decode(Gifs.self, from: data)
            return gifsResponse.data
        } catch {
            throw GifError.invalidData
        }
    }
    
    func fetchBySearchQuery(prompt: String) async throws -> [Gif] {
        let jsonString = """
            {
                "data": [
                    {
                        "id": "sample123",
                        "url": "https://giphy.com/sample123",
                        "title": "Sample Gif"
                    }
                ]
            }
        """
        
        guard let data = jsonString.data(using: .utf8) else {
            throw GifError.invalidData
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gifsResponse = try decoder.decode(Gifs.self, from: data)
            return gifsResponse.data
        } catch {
            throw GifError.invalidData
        }
    }
}
