//
//  SearchResultModel.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

struct AppStoreResult : Codable {
	let trackName: String
	let artistName: String
	let sellerName: String?
	let price: Decimal?
	let averageUserRating: Double?
	let description: String?
	let artworkUrl60: String?
	let artworkUrl512: String?
}
