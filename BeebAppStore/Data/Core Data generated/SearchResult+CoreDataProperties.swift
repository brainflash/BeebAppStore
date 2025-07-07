//
//  SearchResult+CoreDataProperties.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//
//

import Foundation
import CoreData


extension SearchResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResult> {
        return NSFetchRequest<SearchResult>(entityName: "SearchResult")
    }

    @NSManaged public var appName: String?
    @NSManaged public var sellerName: String?
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var rating: Double
    @NSManaged public var appDescription: String?
    @NSManaged public var iconURL: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var searchTerms: NSSet?

}

// MARK: Generated accessors for searchTerms
extension SearchResult {

    @objc(addSearchTermsObject:)
    @NSManaged public func addToSearchTerms(_ value: SearchTerm)

    @objc(removeSearchTermsObject:)
    @NSManaged public func removeFromSearchTerms(_ value: SearchTerm)

    @objc(addSearchTerms:)
    @NSManaged public func addToSearchTerms(_ values: NSSet)

    @objc(removeSearchTerms:)
    @NSManaged public func removeFromSearchTerms(_ values: NSSet)

}

extension SearchResult : Identifiable {

}
