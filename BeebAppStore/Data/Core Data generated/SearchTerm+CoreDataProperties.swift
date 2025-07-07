//
//  SearchTerm+CoreDataProperties.swift
//  BeebAppStore
//
//  Created by Chris Scutt on 04/07/2025.
//
//

import Foundation
import CoreData


extension SearchTerm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchTerm> {
        return NSFetchRequest<SearchTerm>(entityName: "SearchTerm")
    }

    @NSManaged public var term: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var searchResults: NSSet?

}

// MARK: Generated accessors for searchResults
extension SearchTerm {

    @objc(addSearchResultsObject:)
    @NSManaged public func addToSearchResults(_ value: SearchResult)

    @objc(removeSearchResultsObject:)
    @NSManaged public func removeFromSearchResults(_ value: SearchResult)

    @objc(addSearchResults:)
    @NSManaged public func addToSearchResults(_ values: NSSet)

    @objc(removeSearchResults:)
    @NSManaged public func removeFromSearchResults(_ values: NSSet)

}

extension SearchTerm : Identifiable {

}
