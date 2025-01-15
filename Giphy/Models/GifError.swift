//
//  GifError.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 15/01/2025.
//

import Foundation

enum GifError: LocalizedError {
     case invalidURL
     case invalidResponse
     case invalidData
     case unexpected
    
    var failureReason: String? {
        switch self {
            case .invalidURL:
                return "The provided URL is invalid."
            case .invalidResponse:
                return "The server did not return a valid response."
            case .invalidData:
                return "The data returned from the server was invalid."
            case .unexpected:
                return "Unexpected error occurred."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
            case .invalidURL:
                return "Please check the URL and try again."
            case .invalidResponse:
                return "Retry the request later."
            case .invalidData:
                return "Retry the request later."
            case .unexpected:
                return "Contact user support center."
        }
    }
}
