import CoreData
import SwiftUI

@objc(BookAuthor)
class BookAuthor: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var uri: String
    @NSManaged var booksCount: NSNumber
    @NSManaged var updatedAt: Date?
    @NSManaged var didAdd: Bool
    
    @NSManaged var books: NSSet?
}

extension BookAuthor: Identifiable {
    
}

// Books
extension BookAuthor {
    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Book)
    
    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Book)
    
    @objc(addBooks:)
    @NSManaged public func addToBooks(_ value: NSSet)
    
    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ value: NSSet)
}

extension BookAuthor {
    var books_: [Book] {
        get { 
            let set = (books as? Set<Book>) ?? [] 
            return set.sorted {
                $0.title_ < $1.title_
            }
        }
        set { books = NSSet(array: newValue) }
    }
    public var name_: String {
        name ?? "Unkown author"
    }
    public var updatedAt_: Date {
        updatedAt ?? Date(timeIntervalSince1970: 0)
    }
}

extension BookAuthor {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<BookAuthor> {
        let request = NSFetchRequest<BookAuthor>(entityName: "BookAuthor")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
}
