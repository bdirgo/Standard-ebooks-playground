import CoreData
import SwiftUI

@objc(BookCollection)
class BookCollection: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var type: String?
    @NSManaged var updatedAt: Date?
    @NSManaged var itemCount: NSNumber
    @NSManaged var didAdd: Bool
    
    @NSManaged var collectionItems: NSSet?
}

extension BookCollection: Identifiable {

}
extension BookCollection {
    public var updatedAt_: Date {
        updatedAt ?? Date(timeIntervalSince1970: 0)
    }
    public var name_: String {
        name ?? "Collection"
    }
    public var type_: String {
        type ?? "no type"
    }
//    public var itemCountInt: Int {
//        Int(truncating: itemCount) 
//    }
}

extension BookCollection {
    var collectionItems_: [CollectionItem] {
        get {
            let set = (collectionItems as? Set<CollectionItem>) ?? [] 
            return set.sorted { (lhs, rhs) in
                if lhs.position_ == rhs.position_ { // <1>
                    return lhs.book?.title_ ?? "" < rhs.book?.title_ ?? ""
                }
                return lhs.position_ < rhs.position_
            }
        }
        set { collectionItems = NSSet(array: newValue) }
    }
}

extension BookCollection {
    @objc(addCollectionItemsObject:)
    @NSManaged public func addToCollectionItems(_ value: CollectionItem)
    @objc(removeCollectionItemsObject:)
    @NSManaged public func removeFromCollectionItems(_ value: CollectionItem)
    @objc(addCollectionItems:)
    @NSManaged public func addToCollectionItems(_ value: NSSet)
    @objc(removeCollectionItems:)
    @NSManaged public func removeFromCollectionItems(_ value: NSSet)
}

extension BookCollection {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<BookCollection> {
        let request = NSFetchRequest<BookCollection>(entityName: "BookCollection")
        request.sortDescriptors = [NSSortDescriptor(key: "itemCount", ascending: false)]
        request.predicate = predicate
        return request
    }
    static func fetchRequest() -> NSFetchRequest<BookCollection> {
        let request = NSFetchRequest<BookCollection>(entityName: "BookCollection")
        request.sortDescriptors = [NSSortDescriptor(key: "itemCount", ascending: false)]
        return request
    }
}
