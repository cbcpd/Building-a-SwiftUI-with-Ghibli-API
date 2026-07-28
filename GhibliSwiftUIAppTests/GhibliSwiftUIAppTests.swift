//
//  GhibliSwiftUIAppTests.swift
//  GhibliSwiftUIAppTests
//
//  Created by Karin Prater on 10/6/25.
//
import Foundation
import Testing
@testable import GhibliSwiftUIApp

struct GhibliSwiftUIAppTests {

    actor MockGhibliService: GhibliService {
        
        let mockFilms: [Film]
        let shouldThrowError: Bool
        let fetchDelay: Duration
        
        var fetchCallCount = 0
        var lastSearchQuery: String? = nil

        init(mockFilms: [Film],
             shouldThrowError: Bool = false,
             fetchDelay: Duration = .zero) {
            self.mockFilms = mockFilms
            self.shouldThrowError = shouldThrowError
            self.fetchDelay = fetchDelay
        }
        
        //MARK: - Protocol conformance
        
        func fetchFilms() async throws -> [Film] {
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
            
            return mockFilms
        }
        
      func searchFilm(for searchTerm: String) async throws -> [Film] {
            
            self.fetchCallCount += 1
            self.lastSearchQuery = searchTerm
            
            if shouldThrowError {
                throw APIError.networkError(NSError(domain: "Test", code: -1))
            }
            
            if fetchDelay > .zero {
                try? await Task.sleep(for: fetchDelay)
            }
          
            try Task.checkCancellation()
            
            if searchTerm.isEmpty {
                return mockFilms
            }
            
            return mockFilms.filter {
                $0.title.localizedCaseInsensitiveContains(searchTerm)
            }
        }

        func fetchPerson(from URLString: String) async throws -> Person {
            return Person(id: "", name: "", gender: "", age: "", eyeColor: "", hairColor: "", films: [], species: "", url: "")
        }
        
    }

    // MARK: - Test Data
     let mockFilms = [
         Film(
             id: "1",
             title: "My Neighbor Totoro",
             description: "Two sisters discover Totoro",
             director: "Hayao Miyazaki",
             producer: "Isao Takahata",
             releaseYear: "1988",
             score: "93",
             duration: "",
             image: "",
             bannerImage: "",
             people: []
         ),
         Film(
             id: "2",
             title: "Spirited Away",
             description: "A girl enters a spirit world",
             director: "Hayao Miyazaki",
             producer: "Toshio Suzuki",
             releaseYear: "2001",
             score: "97",
             duration: "",
             image: "",
             bannerImage: "",
             people: []
         ),
         Film(
             id: "3",
             title: "Princess Mononoke",
             description: "A prince fights to save the forest",
             director: "Hayao Miyazaki",
             producer: "Toshio Suzuki",
             releaseYear: "1997",
             score: "92",
             duration: "",
             image: "",
             bannerImage: "",
             people: []
         )
     ]
    
    @MainActor
    @Test func testInitialState() async throws {
        let service = MockGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)
        
        #expect(viewModel.state.data == nil)
        
        if case .idle = viewModel.state {
            
        } else {
            Issue.record("Expected idle state")
        }
    }

    @MainActor
    @Test("Search with query filters results")
    func testSearchWithQuery() async {
        let service = MockGhibliService(mockFilms: mockFilms)
        let viewModel = SearchFilmsViewModel(service: service)

        await viewModel.fetch(for: "Totoro")
    
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
    
    @MainActor
    @Test("Search result gives error")
    func testSearchWithError() async {
        let service = MockGhibliService(mockFilms: mockFilms,
                                        shouldThrowError: true)
        let viewModel = SearchFilmsViewModel(service: service)
        
        await viewModel.fetch(for: "Totoro")
    
        #expect(viewModel.state.error != nil)
    }
    
    @MainActor
    @Test("Task cancellation after API call prevents state update")
    func testCancellationAfterAPICall() async {
        let service = MockGhibliService(mockFilms: mockFilms,
                                        fetchDelay: .milliseconds(100))
        let viewModel = SearchFilmsViewModel(service: service)
        
        let task = Task {
            print("started task")
            await viewModel.fetch(for: "tot")
        }
 
        try? await Task.sleep(for: .milliseconds(550))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 1)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == "tot")
        #expect(viewModel.state.error != nil)
    }
    
    @MainActor
    @Test("Test that task is not fetching data too frequently")
    func testDebounceTiming() async {
        let service = MockGhibliService(mockFilms: mockFilms,
                                        fetchDelay: .milliseconds(100))
        let viewModel = SearchFilmsViewModel(service: service)
        
        let task = Task {
            await viewModel.fetch(for: "tot")
        }
 
        // cancel before debounce timing of 500ms is over
        try? await Task.sleep(for: .milliseconds(450))
        task.cancel()
        
        await task.value
        
        let fetchCallCount = await service.fetchCallCount
        #expect(fetchCallCount == 0)
        
        let lastSearchQuery = await service.lastSearchQuery
        #expect(lastSearchQuery == nil)
        #expect(viewModel.state == .idle)
    }
    
    @MainActor
    @Test("Multiple rapid searches only execute the last one")
    func testDebounceWithMultipleSearches() async {
        let service = MockGhibliService(mockFilms: mockFilms)
        
        let viewModel = SearchFilmsViewModel(service: service)
        
        // Simulate rapid typing: "t", "to", "tot", "toto", "totor", "totoro"
        let searchQueries = ["t", "to", "tot", "toto", "totor", "totoro"]
        var tasks: [Task<Void, Never>] = []
        
        for query in searchQueries {
            // Cancel previous task
            tasks.last?.cancel()
            
            let task = Task {
                await viewModel.fetch(for: query)
            }
            tasks.append(task)
            
            // Small delay between keystrokes
            try? await Task.sleep(for: .milliseconds(50)) // shorter then 500ms debounce rate
        }
        
        // Wait for the last task to complete
        await tasks.last?.value
        
        let callCount = await service.fetchCallCount
        let lastQuery = await service.lastSearchQuery
        
        #expect(callCount == 1, "Only the final search should execute")
        #expect(lastQuery == "totoro", "Should search for the final query")
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
    
    @MainActor
    @Test("Multiple slow searches execute all")
    func testDebounceWithSlowMultipleSearches() async {
        let service = MockGhibliService(mockFilms: mockFilms)
        
        let viewModel = SearchFilmsViewModel(service: service)
        
        // Simulate rapid typing: "t", "to", "tot", "toto", "totor", "totoro"
        let searchQueries = ["tot", "totor", "totoro"]
        var tasks: [Task<Void, Never>] = []
        
        for query in searchQueries {
            // Cancel previous task
            tasks.last?.cancel()
            
            let task = Task {
                await viewModel.fetch(for: query)
            }
            tasks.append(task)
            
            // Small delay between keystrokes
            try? await Task.sleep(for: .milliseconds(550))
        }
        
        // Wait for the last task to complete
        await tasks.last?.value
        
        let callCount = await service.fetchCallCount
        let lastQuery = await service.lastSearchQuery
        
        #expect(callCount == 3, "all searchs should execute")
        #expect(lastQuery == "totoro", "Should search for the final query")
        #expect(viewModel.state.data?.count == 1)
        #expect(viewModel.state.data?.first?.title == "My Neighbor Totoro")
    }
}
