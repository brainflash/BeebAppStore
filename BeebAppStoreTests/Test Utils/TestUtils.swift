//
//  TestUtils.swift
//  BeebAppStoreTests
//
//  Created by Chris Scutt on 04/07/2025.
//

import CoreData
import XCTest

class TestUtils {
	
	static let ModelName = "BeebAppStore"
	
	class func inMemoryPersistentContainer() -> (NSPersistentContainer, NSPersistentStoreCoordinator) {
		let container = NSPersistentContainer(name: Self.ModelName) // Replace with your actual model name
		let description = NSPersistentStoreDescription()
		description.type = NSInMemoryStoreType
		container.persistentStoreDescriptions = [description]

		var coordinator: NSPersistentStoreCoordinator!
		let exp = XCTestExpectation(description: "Setup Core Data Stack")
		container.loadPersistentStores { _, error in
			XCTAssertNil(error)
			coordinator = container.persistentStoreCoordinator
			exp.fulfill()
		}
		XCTWaiter().wait(for: [exp], timeout: 1)
		return (container, coordinator)
	}
}
