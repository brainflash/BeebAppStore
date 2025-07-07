//
//  NetworkService.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

protocol NetworkService {
	func fetchApps(for term: String) async throws -> [AppStoreResult]
}
