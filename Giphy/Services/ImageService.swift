//
//  ImageService.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 11/01/2025.
//

import Foundation

protocol ImageServiceProtocol {
    func fetchTrendingImages(completion: @escaping (Result<[Gif], GifError>) -> Void) async
    func fetchBySearchQuery(prompt: String, completion: @escaping (Result<[Gif], GifError>) -> Void) async
}

// todo: should it be final class
final class ImageService: ImageServiceProtocol {
    // todo: hide api key
    let baseUrl: String = "https://api.giphy.com/v1/gifs"
    let apiKey: String = "ZssRaHY74NTtggDA8fQ7JnPI2lKQk7Xw"
    let limit: Int = 50
    var offset: Int = 0
    
    func fetchTrendingImages(completion: @escaping (Result<[Gif], GifError>) -> Void) async -> Void {
        let endpoint = "\(baseUrl)/trending?api_key=\(apiKey)&limit=\(limit)&offset=\(offset)&rating=g&bundle=messaging_non_clips"
         
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gifResponse = try decoder.decode(Gifs.self, from: data)
            
            // todo: explain this
            Task { @MainActor in
                self.offset += gifResponse.data.count
            }
            
            completion(.success(gifResponse.data))
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
    func fetchBySearchQuery(prompt: String, completion: @escaping (Result<[Gif], GifError>) -> Void) async -> Void {
        let endpoint = "\(baseUrl)/search?api_key=\(apiKey)&q=\(prompt)&limit=\(limit)&offset=0&rating=g&lang=en&bundle=messaging_non_clips"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let gifResponse = try decoder.decode(Gifs.self, from: data)
            
            // todo: this may not be needed
            Task { @MainActor in
                self.offset += gifResponse.data.count
            }
            
            completion(.success(gifResponse.data))
        } catch {
            completion(.failure(.invalidData))
        }
    }
    
}
