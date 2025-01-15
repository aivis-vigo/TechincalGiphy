//
//  AnimatedImageViewModel.swift
//  Giphy
//
//  Created by Aivis Vigo Reimarts on 11/01/2025.
//

import Foundation
import Combine

class GifViewModel: ObservableObject {
    private let service: ImageServiceProtocol
    
    // @Published - whenever this value changes send announcement to reload the views
    @Published var trendingResults: [Gif] = []
    @Published var searchResults: [Gif] = []
    
    var imageError: GifError?
    var showError: Bool = false
    
    // @PassthroughObject - broadcasts elements to downstream subs
    private var userInputSearchSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
                /*
                    clear out previous results before giving the new results
                */
                self?.searchResults.removeAll()
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
        /*
            @MainActor has to be used because because @Published property is being updated
         
            @MainActor executes tasks on the main thread
        */
        Task { @MainActor in
            do {
                let trendingImages = try await service.fetchTrendingImages()
                self.trendingResults.append(contentsOf: trendingImages)
            } catch let error as GifError {
                showError = true
                imageError = error
            } catch {
                imageError = .unexpected
            }
        }
    }
    
    func fetchBySearchQuery(searchInput: String) async -> Void {
        Task { @MainActor in
            do {
                let searchResults = try await service.fetchBySearchQuery(prompt: searchInput)
                self.searchResults.append(contentsOf: searchResults)
            } catch let error as GifError {
                showError = true
                imageError = error
            } catch {
                imageError = .unexpected
            }
        }
    }
    
}
