//
//  SearchResponse.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

struct SearchResponse : Codable {
	let resultCount: Int
	let results: [AppStoreResult]
}
