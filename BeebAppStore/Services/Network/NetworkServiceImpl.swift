//
//  NetworkServiceImpl.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

class NetworkServiceImpl : NetworkService {
	
	func fetchApps(for term: String) async throws -> [AppStoreResult] {
		guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
			throw NetworkError.decodingError(reason: "Could not URL encode search term")
		}
		
		let baseURL = "https://itunes.apple.com/search"
		let query = "?media=software&entity=software&country=gb&term=\(encodedTerm)"
		guard let url = URL(string: baseURL + query) else {
			throw NetworkError.invalidURL
		}
		
		let (data, _) = try await URLSession.shared.data(from: url)
		
		let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
		return decoded.results
	}
}
