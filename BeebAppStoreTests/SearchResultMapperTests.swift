//
//  SearchResultMapperTests.swift
//  BeebAppStoreTests
//
//  Created by Chris Scutt on 04/07/2025.
//

import XCTest
import CoreData
@testable import BeebAppStore

final class SearchResultMapperTests : XCTestCase {
	var persistentContainer: NSPersistentContainer!
	var testContext: NSManagedObjectContext!

	override func setUp() {
		super.setUp()
		testContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		let (container, coordinator) = TestUtils.inMemoryPersistentContainer()
		persistentContainer = container
		testContext.persistentStoreCoordinator = coordinator
	}

	func testMapReturnsCorrectSearchResults() {
		let mockResult = AppStoreResult(
			trackName: "iPlayer",
			artistName: "BBC Apps",
			sellerName: "BBC",
			price: 0.99,
			averageUserRating: 4.9,
			description: "Stream your favourite shows",
			artworkUrl60: "https://itunes.site/icon.png",
			artworkUrl512: "https://itunes.site/image.png"
		)

		let context = persistentContainer.viewContext
		let results = SearchResultMapper.map(results: [mockResult], in: context)

		XCTAssertEqual(results.count, 1)
		let result = results.first!
		XCTAssertEqual(result.appName, "iPlayer")
		XCTAssertEqual(result.appDescription, "Stream your favourite shows")
		XCTAssertEqual(result.iconURL, "https://itunes.site/icon.png")
		XCTAssertEqual(result.imageURL, "https://itunes.site/image.png")
		XCTAssertEqual(result.price as? Decimal, 0.99)
		XCTAssertEqual(result.rating, 4.9)
		XCTAssertEqual(result.sellerName, "BBC")
	}

	func testMapReturnsCorrectSearchResultsWithFieldsMissing() {
		let mockResult = AppStoreResult(
			trackName: "iPlayer",
			artistName: "BBC Apps",
			sellerName: "BBC",
			price: 0.99,
			averageUserRating: 4.9,
			description: nil,
			artworkUrl60: nil,
			artworkUrl512: nil
		)

		let context = persistentContainer.viewContext
		let results = SearchResultMapper.map(results: [mockResult], in: context)

		XCTAssertEqual(results.count, 1)
		let result = results.first!
		XCTAssertEqual(result.appName, "iPlayer")
		XCTAssertEqual(result.appDescription, "")
		XCTAssertEqual(result.iconURL, "")
		XCTAssertEqual(result.imageURL, "")
		XCTAssertEqual(result.price as? Decimal, 0.99)
		XCTAssertEqual(result.rating, 4.9)
		XCTAssertEqual(result.sellerName, "BBC")
	}
}
