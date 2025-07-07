//
//  MainViewModelTests.swift
//  BeebAppStoreTests
//
//  Created by Chris Scutt on 04/07/2025.
//

import XCTest
import CoreData
@testable import BeebAppStore

final class MainViewModelTests : XCTestCase {

	var persistentContainer: NSPersistentContainer!
	var testContext: NSManagedObjectContext!
	
	override func setUp() {
		super.setUp()
		testContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		let (container, coordinator) = TestUtils.inMemoryPersistentContainer()
		persistentContainer = container
		testContext.persistentStoreCoordinator = coordinator
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
	
	func assertEqualSearchResults(_ first: SearchResult, _ other: SearchResult) {
		XCTAssertEqual(first.appName, other.appName)
		XCTAssertEqual(first.appDescription, other.appDescription)
		XCTAssertEqual(first.iconURL, other.iconURL)
		XCTAssertEqual(first.imageURL, other.imageURL)
		XCTAssertEqual(first.price, other.price)
		XCTAssertEqual(first.rating, other.rating)
		XCTAssertEqual(first.sellerName, other.sellerName)
	}
	
	func testPerformSearchSuccess() async throws {
		
		let mockResults: [AppStoreResult] = [
			AppStoreResult(trackName: "iPlayer",
						   artistName: "BBC",
						   sellerName: "BBC Sales",
						   price: 0.99,
						   averageUserRating: 4.9,
						   description: "Stream your favourite television and radio programmes",
						   artworkUrl60: "https://itunes.cdn/artwork60.png",
						   artworkUrl512: "https://itunes.cdn/artwork512.png")
		]
		
		let network = MockNetworkService(mode: .success(mockResults))
		let searchManager = MockSearchManager(context: testContext)

		let viewModel = MainViewModel(searchManager: searchManager, networkService: network)

		let expected = [makeSearchResult(appName: "iPlayer", appDescription: "Stream your favourite television and radio programmes", iconURL: "https://itunes.cdn/artwork60.png", imageURL: "https://itunes.cdn/artwork512.png", price: 0.99, rating: 4.9, sellerName: "BBC Sales")]

		let results = try await viewModel.performSearch(for: "Test")

		XCTAssertEqual(results.count, 1)
		for (result, expected) in zip(results, expected) {
			assertEqualSearchResults(result, expected)
		}
		XCTAssertEqual(results.first?.appName, expected.first?.appName)
		XCTAssertEqual(results.first?.appName, expected.first?.appName)
		XCTAssertEqual(searchManager.savedResults.count, 1)
	}

	func testPerformSearchNetworkFailsReturnsCachedResults() async throws {
		let cached = [makeSearchResult(appName: "Cached App Name", appDescription: "Cached App Description", iconURL: "https://itunes.cdn/cached60.png", imageURL: "https://itunes.cdn/cached512.png", price: 1.23, rating: 3.4, sellerName: "Cached Seller Name")]

		
		let searchManager = MockSearchManager(context: testContext)
		searchManager.fetchResultsMap["Test Cached"] = cached

		let network = MockNetworkService(mode: .failure(NSError(domain: "Network", code: -123)))

		let viewModel = MainViewModel(searchManager: searchManager, networkService: network)

		let expected = [makeSearchResult(appName: "Cached App Name", appDescription: "Cached App Description", iconURL: "https://itunes.cdn/cached60.png", imageURL: "https://itunes.cdn/cached512.png", price: 1.23, rating: 3.4, sellerName: "Cached Seller Name")]

		let results = try await viewModel.performSearch(for: "Test Cached")
		
		XCTAssertEqual(results.count, 1)
		for (result, expected) in zip(results, expected) {
			assertEqualSearchResults(result, expected)
		}
	}
	
	func testPerformSearchFailsWithNoCachedResults() async {
		let searchManager = MockSearchManager(context: testContext)
		let network = MockNetworkService(mode: .failure(NSError(domain: "Network", code: -123)))

		let viewModel = MainViewModel(searchManager: searchManager, networkService: network)

		do {
			_ = try await viewModel.performSearch(for: "Test App Name")
			XCTFail("Throw was expected")
		} catch {
			XCTAssertTrue((error as NSError).domain == "Network")
			XCTAssertTrue((error as NSError).code == -123)
		}
	}
}
