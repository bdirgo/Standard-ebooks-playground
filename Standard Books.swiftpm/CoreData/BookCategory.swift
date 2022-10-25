import CoreData
import SwiftUI

@objc(BookCategory)
class BookCategory: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var booksCount: NSNumber
    @NSManaged var updatedAt: Date?
    @NSManaged var didAdd: Bool
    @NSManaged var isSESubject: Bool
    
    @NSManaged var books: NSSet?
}

extension BookCategory: Identifiable {
    
}
extension BookCategory {
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
    public var updatedAt_: Date {
        updatedAt ?? Date(timeIntervalSince1970: 0)
    }
    public var count: Int {
        Int(truncating: booksCount)
    }
    public var name_: String {
        name ?? "Unknown Category"
    }
}
// Books
extension BookCategory {
    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)
    
    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)
    
    @objc(addBooks:)
    @NSManaged public func addToBooks(_ value: NSSet)
    
    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ value: NSSet)
}

extension BookCategory {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<BookCategory> {
        let request = NSFetchRequest<BookCategory>(entityName: "BookCategory")
        request.sortDescriptors = [NSSortDescriptor(key: "booksCount", ascending: false)]
        request.predicate = predicate
        return request
    }
    static func fetchRequest() -> NSFetchRequest<BookCategory> {
        let request = NSFetchRequest<BookCategory>(entityName: "BookCategory")
        request.sortDescriptors = [NSSortDescriptor(key: "booksCount", ascending: false)]
        //request.predicate = predicate
        return request
    }
}

