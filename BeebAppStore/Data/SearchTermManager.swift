//
//  SearchTermManager.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

protocol SearchTermManager {
	func fetchResults(for term: String) -> [SearchResult]?
	func saveSearch(term: String, withResults results: [AppStoreResult]) -> [SearchResult]
}
