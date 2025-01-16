//
//  ImageServiceTests.swift
//  GiphyTests
//
//  Created by Aivis Vigo Reimarts on 16/01/2025.
//

import XCTest
@testable import Giphy

final class ImageServiceTests: XCTestCase {

    func testSuccessfulTrendinImageResult () async throws    {
        let imageService = ImageService()
        
        do {
            let trendingResults: [Gif] = try await imageService.fetchTrendingImages()
            XCTAssertFalse(trendingResults.isEmpty, "Trending images should not be empty")
        } catch {
            XCTFail("Fetching trending images failed with error: \(error)")
        }
    }
    
}
