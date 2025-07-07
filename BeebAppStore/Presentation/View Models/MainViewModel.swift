//
//  MainViewModel.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

class MainViewModel : NSObject {
	private let searchManager: SearchTermManager!
	private let networkService: NetworkService!

	init(searchManager: SearchTermManager, networkService: NetworkService) {
		self.searchManager = searchManager
		self.networkService = networkService
	}
	
	func performSearch(for term: String) async throws -> [SearchResult] {
		do {
			let results = try await networkService.fetchApps(for: term)
			let searchResults = searchManager.saveSearch(term: term, withResults: results)
			return searchResults
		} catch {
			if let cached = searchManager.fetchResults(for: term), !cached.isEmpty {
				return cached
			} else {
				throw error
			}
		}
	}
}
