//
//  MockSearchManager.swift
//  BeebAppStoreTests
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation
import CoreData
@testable import BeebAppStore

class MockSearchManager: SearchTermManager {
	let context: NSManagedObjectContext!
	var savedResults: [AppStoreResult] = []
	var fetchResultsMap: [String: [SearchResult]] = [:]

	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	func fetchResults(for term: String) -> [SearchResult]? {
		return fetchResultsMap[term]
	}

	func saveSearch(term: String, withResults results: [AppStoreResult]) -> [SearchResult] {
		let mappedResults = SearchResultMapper.map(results: results, in: context)
		savedResults = results
		fetchResultsMap[term] = mappedResults
		return mappedResults
	}
}
