//
//  SearchTermManagerTests.swift
//  BeebAppStoreTests
//
//  Created by Chris Scutt on 04/07/2025.
//

import XCTest
import CoreData
@testable import BeebAppStore

final class SearchTermManagerTests: XCTestCase {
	
	var persistentContainer: NSPersistentContainer!
	var testContext: NSManagedObjectContext!

	var manager: SearchTermManagerImpl!

	override func setUp() {
		super.setUp()
		testContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		let (container, coordinator) = TestUtils.inMemoryPersistentContainer()
		persistentContainer = container
		testContext.persistentStoreCoordinator = coordinator
	}

	override func tearDown() {
		manager = nil
		persistentContainer = nil
		super.tearDown()
	}
	
	func testSaveSearchAndFetchResults() {
		let mockResults = [
			AppStoreResult(
				trackName: "iPlayer",
				artistName: "BBC Apps",
				sellerName: "BBC",
				price: 0.99,
				averageUserRating: 4.9,
				description: "Stream your favourite shows",
				artworkUrl60: "https://itunes.site/icon.png",
				artworkUrl512: "https://itunes.site/image.png"
			)
		]

		manager = SearchTermManagerImpl(context: testContext)

		let results = manager.saveSearch(term: "bbc", withResults: mockResults)
		XCTAssertEqual(results.count, 1)

		let fetched = manager.fetchResults(for: "bbc")
		XCTAssertNotNil(fetched)
		XCTAssertEqual(fetched?.count, 1)
		XCTAssertEqual(fetched?.first?.appName, "iPlayer")
	}
		
	func testFetchReturnsNilForUnknownTerm() {
		manager = SearchTermManagerImpl(context: testContext)

		let results = manager.fetchResults(for: "nonexistent")
		XCTAssertNil(results)
	}
	
	func makeSearchResult(appName: String, appDescription: String, iconURL: String, imageURL: String, price: Decimal, rating: Double, sellerName: String) -> SearchResult {
		let result = SearchResult(context: testContext)
		result.appName = appName
		result.appDescription = appDescription
		result.iconURL = iconURL
		result.imageURL = imageURL
		result.price = price as NSDecimalNumber
		result.rating = rating
		result.sellerName = sellerName
		
		do {
			try testContext.save()
		} catch {
			XCTFail("Failed to save SearchResult: \(error)")
		}
		
		return result
	}
	
	func testSearchTermNotDuplicatedAndSearchResultShared() throws {

		let result1 = makeSearchResult(appName: "iPlayer", appDescription: "Stream your favourite television and radio programmes", iconURL: "https://itunes.cdn/artwork60.png", imageURL: "https://itunes.cdn/artwork512.png", price: 0.99, rating: 4.9, sellerName: "BBC Sales")
		
		// Search term 1
		let term1 = SearchTerm(context: testContext)
		term1.term = "bbc"
		term1.addToSearchResults(result1)

		// Search term 2
		let term2 = SearchTerm(context: testContext)
		term2.term = "tv"
		term2.addToSearchResults(result1)

		try testContext.save()

		// Fetch the terms
		let fetch: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
		let terms = try testContext.fetch(fetch)
		XCTAssertEqual(terms.count, 2)

		// Assert each SearchTerm has 1 shared result
		for term in terms {
			guard let results = term.searchResults else {
				XCTFail("Term has no results")
				continue
			}
			XCTAssertEqual(results.count, 1)
			let result = results.anyObject() as! SearchResult
			XCTAssertEqual(result.appName, "iPlayer")
			XCTAssertEqual(result.sellerName, "BBC Sales")
		}

		// Assert the result is linked to both terms
		let fetchResult: NSFetchRequest<SearchResult> = SearchResult.fetchRequest()
		let allResults = try testContext.fetch(fetchResult)
		XCTAssertEqual(allResults.count, 1)

		let fetchedResult = allResults.first!
		XCTAssertEqual(fetchedResult.searchTerms?.count, 2)
	}
}

