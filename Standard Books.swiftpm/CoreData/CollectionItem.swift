import CoreData
import SwiftUI

@objc(CollectionItem)
class CollectionItem: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var rank: NSNumber? // how the book ranks all of the series it is in
    @NSManaged var position: NSNumber? // position in this series (ie. BookCollection)
    @NSManaged var updatedAt: Date?
    @NSManaged var bookId: String?
    
    @NSManaged var collection: BookCollection?
    @NSManaged var book: Book?
}

extension CollectionItem: Identifiable {
    
}

extension CollectionItem {
    public var updatedAt_: Date {
        updatedAt ?? Date(timeIntervalSince1970: 0)
    }
    public var name_: String {
        name ?? "Collection"
    }
    public var rank_: Int {
        Int(truncating: rank ?? 0)
    }
    public var position_: Int {
        Int(truncating: position ?? 0) 
    }
}

extension CollectionItem {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<CollectionItem> {
        let request = NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true), NSSortDescriptor(key: "rank", ascending: true)]
        request.predicate = predicate
        return request
    }
}
