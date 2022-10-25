import CoreData
import SwiftUI

@objc(BookSubject)
class BookSubject: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var symbolName: String?
    @NSManaged var updatedAt: Date?
    @NSManaged var booksCount: NSNumber
    @NSManaged var didAdd: Bool
    @NSManaged var isSESubject: Bool
    
    @NSManaged var books: NSSet?
}

extension BookSubject: Identifiable {

}

// Books
extension BookSubject {
    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)
    
    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)
    
    @objc(addBooks:)
    @NSManaged public func addToBooks(_ value: NSSet)
    
    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ value: NSSet)
}

extension BookSubject {
    var books_: [Book] {
        get { 
            let set = (books as? Set<Book>) ?? [] 
            return set.sorted { (lhs, rhs) in
//                if lhs.firstAuthor == rhs.firstAuthor { // <1>
//                    return lhs.title_ < rhs.title_
//                }
//                
                return lhs.issued_ > rhs.issued_ // <2>
            }
        }
        set { books = NSSet(array: newValue) }
    }
    public var name_: String {
        name ?? "Unkown Subject name"
    }
    public var symbolName_: String {
        symbolName ?? "42.circle.fill"
    }
    public var updatedAt_: Date {
        updatedAt ?? Date(timeIntervalSince1970: 0)
    }
}

extension BookSubject {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<BookSubject> {
        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
    static func fetchRequest() -> NSFetchRequest<BookSubject> {
        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        request.predicate = predicate
        return request
    }
}

