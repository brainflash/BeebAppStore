//
//  SearchResult+Extension.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//

import CoreData

extension SearchResult {
	
	convenience init(context: NSManagedObjectContext,
					 appDescription: String?,
					 appName: String?,
					 iconURL: String?,
					 imageURL: String?,
					 price: Decimal?,
					 rating: Double?,
					 sellerName: String?) {
		
		let entity = NSEntityDescription.entity(forEntityName: "SearchResult", in: context)!
		self.init(entity: entity, insertInto: context)

		self.appDescription = appDescription
		self.appName = appName
		self.iconURL = iconURL
		self.imageURL = imageURL
		self.price = price as? NSDecimalNumber ?? 0.0
		self.rating = rating ?? 0.0
		self.sellerName = sellerName
	}
	
	var priceString: String? {
		guard let price, price.doubleValue > 0 else {
			return "Free"
		}
		
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = .current
		
		return formatter.string(from: price as NSDecimalNumber)
	}
	
	var ratingString: String? {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = 1
		formatter.maximumFractionDigits = 1
		
		return formatter.string(from: NSNumber(value: rating))
	}
}
