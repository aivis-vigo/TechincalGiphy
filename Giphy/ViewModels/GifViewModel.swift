//
//  AnimatedImageViewModel.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 11/01/2025.
//

import Foundation
import Combine

class GifViewModel: ObservableObject {
    // @Published - whenever this value changes send announcement to reload the views
    @Published var trendingCollection: [Gif] = []
    @Published var searchResults: [Gif] = []
    // @PassthroughObject - broadcasts elements to downstream subs
    private var userInputSearchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let service: ImageServiceProtocol
    
    init(service: ImageServiceProtocol = ImageService()) {
        self.service = service
        
        /*
            .debounce - publish elements after 0.5 seconds between the events
            .sink - subscribes to a publisher (userInputSearchSubject - emits values over time)
         
            after user has stopped typing for 0.5 seconds a value is emitted and
            async API call is executed
        */
        userInputSearchSubject
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] prompt in
                Task {
                    await self?.fetchBySearchQuery(searchInput: prompt)
                }
            }
            .store(in: &cancellables)
    }
    
    /*
        every value that has been typed in a search bar is sent to publisher to
        track when there is a 0.5 second interval break between keystrokes
    */
    func updateSearch(userSearchInput: String) {
        self.userInputSearchSubject.send(userSearchInput)
    }
        
    func fetchTrendingImages() async -> Void {
        Task {
            await service.fetchTrendingImages { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let images):
                            // todo: handle this
                            self.trendingCollection.append(contentsOf: images)
                        case .failure(let error):
                            self.handleImageError(error)
                    }
                }
            }
        }
    }
    
    func fetchBySearchQuery(searchInput: String) async -> Void {
        Task {
            await service.fetchBySearchQuery(prompt: searchInput) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let images):
                        self.searchResults.append(contentsOf: images)
                    case .failure(let error):
                        self.handleImageError(error)
                    }
                }
            }
        }
    }
    
    func handleImageError(_ error: GifError) -> Void {
        let errorMessage: String
        switch error {
            case .invalidURL:
                errorMessage = "Invalid URL"
            case .invalidResponse:
                errorMessage = "Invalid Response"
            case .invalidData:
                errorMessage = "Invalid Data"
        }
        print("Error: \(errorMessage)")
    }
    
}
