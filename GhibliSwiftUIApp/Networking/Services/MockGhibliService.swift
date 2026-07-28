//
//  MockGhibliService.swift
//  GhibliSwiftUIApp
//
//  Created by Karin Prater on 10/6/25.
//

import Foundation

struct MockGhibliService: GhibliService {
    
    private struct SampleData: Decodable {
        let films: [Film]
        let people: [Person]
    }
    
    private func loadSampleData() throws -> SampleData {
         guard let url = Bundle.main.url(forResource: "SampleData", withExtension: "json") else {
             throw APIError.invalideURL
         }
         do {
             let data = try Data(contentsOf: url)
             return try JSONDecoder().decode(SampleData.self, from: data)
         } catch let error as DecodingError {
             print(error)
             throw APIError.decoding(error)
         } catch {
             throw APIError.networkError(error)
         }
     }
    
    //MARK: - Protocol conformance
    
    func fetchFilms() async throws -> [Film] {
        let data = try loadSampleData()
        return data.films
    }
    
    func searchFilm(for searchTerm: String) async throws -> [Film] {
        let allFilms = try await fetchFilms()
        
        return allFilms.filter { film in
            film.title.localizedStandardContains(searchTerm)
        }
    }

    func fetchPerson(from URLString: String) async throws -> Person {
        let data = try loadSampleData()
        return data.people.first!
    }
    
    //MARK: - preview/testing only
    
    func fetchFilm() -> Film {
        let data = try! loadSampleData()
        return data.films.first!
    }
}
