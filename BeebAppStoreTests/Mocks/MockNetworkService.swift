//
//  MockNetworkService.swift
//  BeebAppStoreTests
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation
import CoreData
@testable import BeebAppStore

class MockNetworkService: NetworkService {
	enum Mode {
		case success([AppStoreResult])
		case failure(Error)
	}
	
	var mode: Mode
	
	init(mode: Mode) {
		self.mode = mode
	}
	
	func fetchApps(for term: String) async throws -> [AppStoreResult] {
		switch mode {
		case .success(let results):
			return results
		case .failure(let error):
			throw error
		}
	}
}
