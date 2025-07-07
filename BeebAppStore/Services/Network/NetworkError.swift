//
//  NetworkError.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import Foundation

enum NetworkError: Error {
	case invalidURL
	case noData
	case requestFailed(Error)
	case decodingError(reason: String)
}
