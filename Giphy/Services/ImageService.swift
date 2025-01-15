//
//  ImageService.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 11/01/2025.
//

import Foundation

/*
    class needs to have these methods
*/

protocol ImageServiceProtocol {
    func fetchTrendingImages() async throws -> [Gif]
    func fetchBySearchQuery(prompt: String) async throws -> [Gif]
}

/*
    final - class isn't meant to be inherited
*/

final class ImageService: ImageServiceProtocol {
    private let apiKey: String
    let baseUrl: String = "https://api.giphy.com/v1/gifs"
    let limit: Int = 50
    var offset: Int = 0
    
    init() {
        self.apiKey = ImageService.loadAPIKey()
    }
    
    private static func loadAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "secret-config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let apiKey = plist["GIPHY_API_KEY"] as? String else {
            fatalError("Missing GIPHY_API_KEY in secret-config.plist")
        }
        return apiKey
    }
    
    func fetchTrendingImages() async throws -> [Gif] {
        let endpoint = "\(baseUrl)/trending?api_key=\(apiKey)&limit=\(limit)&offset=\(offset)&rating=g&bundle=messaging_non_clips"
         
        guard let url = URL(string: endpoint) else {
            throw GifError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GifError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gifResponse = try decoder.decode(Gifs.self, from: data)
            
            Task { @MainActor in
                self.offset += gifResponse.data.count
            }
            
            return Array(gifResponse.data)
        } catch {
            throw GifError.invalidData
        }
    }
    
    func fetchBySearchQuery(prompt: String) async throws -> [Gif] {
        let endpoint = "\(baseUrl)/search?api_key=\(apiKey)&q=\(prompt)&limit=\(limit)&offset=0&rating=g&lang=en&bundle=messaging_non_clips"
        
        guard let url = URL(string: endpoint) else {
            throw GifError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GifError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gifResponse = try decoder.decode(Gifs.self, from: data)
            
            Task { @MainActor in
                self.offset += gifResponse.data.count
            }
            
            return Array(gifResponse.data)
        } catch {
            throw GifError.invalidData
        }
    }
}
