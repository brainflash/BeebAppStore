//
//  SearchResultMapper.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import CoreData

class SearchResultMapper {
	
	class func map(results: [AppStoreResult], in context: NSManagedObjectContext) -> [SearchResult] {
		var mapped = [SearchResult]()
		
		context.performAndWait {
			mapped = results.map { result in
				SearchResult(
					context: context,
					appDescription: result.description ?? "",
					appName: result.trackName,
					iconURL: result.artworkUrl60 ?? "",
					imageURL: result.artworkUrl512 ?? "",
					price: result.price,
					rating: result.averageUserRating,
					sellerName: result.sellerName
				)
			}
		}
		return mapped
	}
}
