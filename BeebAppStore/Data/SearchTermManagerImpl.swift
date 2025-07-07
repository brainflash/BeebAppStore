//
//  SearchTermManagerImpl.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation
import CoreData

class SearchTermManagerImpl : SearchTermManager {
	private let context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	func fetchResults(for term: String) -> [SearchResult]? {
		let request: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
		request.predicate = NSPredicate(format: "term == %@", term)
		
		guard let match = try? context.fetch(request).first else {
			return nil
		}
		
		return match.searchResults?.allObjects as? [SearchResult]
	}
	
	func saveSearch(term: String, withResults results: [AppStoreResult]) -> [SearchResult] {
		let searchTerm = SearchTerm(context: context)
		searchTerm.term = term
		searchTerm.timestamp = Date()
		
		let mappedResults = SearchResultMapper.map(results: results, in: context)
		let searchResults = mappedResults.map { result in
			searchTerm.addToSearchResults(result)
			return result
		}
		
		do {
			try context.save()
		} catch {
			print("Error saving context: \(error)")
		}
		return searchResults
	}
}
