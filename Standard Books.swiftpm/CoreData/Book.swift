import CoreData
import SwiftUI

@objc(Book)
class Book: NSManagedObject {
//    Attributes
    @objc @NSManaged var id: String
    @objc @NSManaged var url: String
    @objc @NSManaged var title: String?
    @objc @NSManaged var summary: String?
    @objc @NSManaged var content: String?
    @objc @NSManaged var language: String?
    @objc @NSManaged var coverUrl: String?
    @objc @NSManaged var thumbnailUrl: String?
    @objc @NSManaged var ePubUrl: String?
    @objc @NSManaged var ePubLength: NSNumber?
    @objc @NSManaged var wikipedia: String?
    @objc @NSManaged var wordCount: NSNumber?
    @objc @NSManaged var readingEase: NSNumber?
    @objc @NSManaged var issued: Date?
    @objc @NSManaged var updatedAt: Date?
    @objc @NSManaged var didDownload: Bool
    @objc @NSManaged var didAdd: Bool
    @objc @NSManaged var didAddGithub: Bool
//    Relationships
    @objc @NSManaged var authors: NSSet?
    @objc @NSManaged var categories: NSSet?
    @objc @NSManaged var subjects: NSSet?
    @objc @NSManaged var collectionItems: NSSet?
    @objc @NSManaged var audiobook: LibrivoxBook?
    
    @objc override public func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
        self.objectWillChange.send()
    }
}

extension Book {
    @objc public var summary_: String {
        summary ?? ""
    }
    @objc public var title_: String {
        title ?? "Unknown Title"
    }
    @objc public var language_: String {
        language?.replacingOccurrences(of: "-", with: "_") ?? "en_US"
    }
    @objc public var fileName: String {
        "\(title_.mixedSnakeCased())_\(firstAuthor.mixedSnakeCased()).epub"
    }
    @objc public var ePubFileSize: String {
        let kb = Int(truncating: ePubLength ?? 0) / 1000
        if kb > 1000 {
            return "\(kb / 1000) MB"
        }
        return "\(kb) KB"
    }
    @objc public var githubSearchName: String {
        "\(firstAuthor.lowerKebabCased())_\(title_.lowerKebabCased())"
    }
    @objc public var coverUrl_: String {
        coverUrl ?? "/"
    }
    @objc public var thumbnailUrl_: String {
        thumbnailUrl ?? "/"
    }
    @objc public var ePubUrl_: String {
        ePubUrl ?? "/"
    }
    @objc public var content_: String {
        content ?? ""
    }
    @objc public var issued_: Date {
        issued ?? Date(timeIntervalSince1970: 0)
    }
    @objc public var updatedAt_: Date {
        updatedAt ?? Date(timeIntervalSince1970: 0)
    }
    @objc public var wordCount_: Int {
        Int(truncating: wordCount ?? 0)
    }
    @objc public var readingEase_: Double {
        Double(truncating: readingEase ?? 0)
    }
    @objc public var readingEaseString: String {
        if readingEase_ >= 90 {
            return "Very Easy"
        } else if readingEase_ >= 80 && readingEase_ < 90 {
            return "Easy"
        } else if readingEase_ >= 70 && readingEase_ < 80 {
            return "Fairly Easy"
        } else if readingEase_ >= 60 && readingEase_ < 70 {
            return "Average"
        } else if readingEase_ >= 50 && readingEase_ < 60 {
            return "Fairly Difficult"
        } else if readingEase_ >= 30 && readingEase_ < 50 {
            return "Difficult"
        } else if readingEase_ >= 0 && readingEase_ < 30 {
            return "Very Difficult"
        } else {
            return ""
        }
    }
    @objc public var hasAudiobook: Bool {
//        print(audiobook)
        return audiobook?.url != nil
    }
    @objc public var wikipedia_: String {
        wikipedia ?? ""
    }
    @objc public var firstUniqueSubject: BookSubject? {
        if subjects_.count > 1 {
            return subjects_.filter {
                $0.name_ != "Fiction" && $0.name_ != "Non-Fiction"
            }.first
        } else {
            return subjects_.first
        }
    }
//    for use with canvas previews.
//    static var preview: Book {
//        let quakes = Book.makePreviews(count: 1)
//        return quakes[0]
//    }
        
//    @discardableResult
//    static func makePreviews(viewContext: NSManagedObjectContext, count: Int = 1) -> [Book] {
//        var books = [Book]()
////        let viewContext = PersistenceController.preview.container.viewContext
//        var collections = [BookCollection]()
//        for jndex in 1...3 {
//            let rand = Int.random(in:1...3)
//            let collection = BookCollection(context: viewContext)
//            if rand == 1 {
//                collection.name = "Colletion Series \(jndex)"
//                collection.type = "series"
//            } else {
//                collection.name = "Collection Set \(jndex)"
//                collection.type = "set"
//            }
//            collections.append(collection)
//        }
//        for index in 0..<count {
//            let book = Book(context: viewContext)
//            let bookId = "https://standardebooks.org/ebook/\(index)"
//            book.title = "Book Title \(index)"
//            book.url = bookId
//            book.summary = "This is the summary."
//            book.content = "<p>This is a longer summary</p><p>It will be in an <em><a href=\"http://google.com\">HTML</a> format</em>."
//            book.coverUrl = "https://standardebooks.org/images/logo.png"
//            book.thumbnailUrl = "https://standardebooks.org/images/logo.png"
//            book.ePubUrl = "https://standardebooks.org/images/logo.png"
//            book.wikipedia = "https://wikipedia.org"
//            let wordCount = 10234 * index 
//            book.wordCount = wordCount as NSNumber
//            let ease = 68 + index
//            book.readingEase = ease as NSNumber
//            book.issued = Date()
//            book.updatedAt = Date()
//            let author = BookAuthor(context: viewContext)
//            author.name = "Author P. Name"
//            book.addToAuthors(author)
//            for jndex in 1...3 {
//                let category = BookCategory(context: viewContext)
//                category.name = "Category \(jndex)"
//                book.addToCategories(category)
//            }
//            for jndex in 1...3 {
//                let subject = BookSubject(context: viewContext)
//                subject.name = "Subject \(jndex)"
//                subject.symbolName = "star.fill"
//                book.addToSubjects(subject)
//            }
//            for jndex in 1...3 {
//                let collectionItem = CollectionItem(context: viewContext)
//                collectionItem.bookId = bookId
//                collectionItem.collection = collections[jndex]
//                collectionItem.name = collections[jndex].name
//                collectionItem.position = index as NSNumber
//                collectionItem.rank = jndex as NSNumber
//                book.addToCollectionItems(collectionItem)
//            }
//            books.append(book)
//        }
//        return books
//    }
}

extension Book: Identifiable {
    
}

extension Book {
    @objc var subjects_: [BookSubject] {
        get {
            let set = (subjects as? Set<BookSubject>) ?? [] 
            return set.sorted {
                $0.name_ < $1.name_
            }
        }
        set { subjects = NSSet(array: newValue) }
    }
    var firstAuthor: String {
        authors_.first?.name_ ?? "Unknown first author"
    }
    @nonobjc var authors_: [BookAuthor] {
        get {
            let set = (authors as? Set<BookAuthor>) ?? [] 
            return set.sorted {
                $0.name_ > $1.name_ // might be wrong
            }
        }
        set { authors = NSSet(array: newValue) }
    }
    @objc var categories_: [BookCategory] {
        get {
            let set = (categories as? Set<BookCategory>) ?? []
            
            return set.filter {
                !$0.isSESubject
            }
                .sorted {
                    if $0.count == $1.count { // <1>
                        return $0.name_ > $1.name_
                    }
                    
                    return $0.count > $1.count // <2>
                }
//                $0.count > $1.count
//                Int(truncating: $0.booksCount) < Int(truncating: $1.booksCount)
            
        }
        set { categories = NSSet(array: newValue) }
    }
    @objc var collectionItems_: [CollectionItem] {
        get {
            let set = (collectionItems as? Set<CollectionItem>) ?? [] 
            return set.sorted {
                $0.rank_ < $1.rank_
            }
        }
        set { collectionItems = NSSet(array: newValue) }
    }
    public var collectionSets: [CollectionItem] {
        get {
            let set = (collectionItems as? Set<CollectionItem>) ?? [] 
            return set.sorted {
                $0.rank_ < $1.rank_
            }.filter { item in
                item.collection?.type == "set"
            }
        }
    }
    
    public var collectionSeries: [CollectionItem] {
        get {
            let set = (collectionItems as? Set<CollectionItem>) ?? [] 
            return set.sorted {
                $0.rank_ < $1.rank_
            }.filter { item in
                item.collection?.type == "series"
            }
        }
    }
    
}

// Categories
extension Book {
    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: BookCategory)
    
    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: BookCategory)
    
    @objc(addCategories:)
    @NSManaged public func addToCategories(_ value: NSSet)
    
    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ value: NSSet)
}

// Authors
extension Book {
    @objc(addAuthorsObject:)
    @NSManaged public func addToAuthors(_ value: BookAuthor)
    
    @objc(removeAuthorsObject:)
    @NSManaged public func removeFromAuthors(_ value: BookAuthor)
    
    @objc(addAuthors:)
    @NSManaged public func addToAuthors(_ value: NSSet)
    
    @objc(removeAuthors:)
    @NSManaged public func removeFromAuthors(_ value: NSSet)
}

// Subjects
extension Book {
    @objc(addSubjectsObject:)
    @NSManaged public func addToSubjects(_ value: BookSubject)
    
    @objc(removeSubjectsObject:)
    @NSManaged public func removeFromSubjects(_ value: BookSubject)
    
    @objc(addSubjects:)
    @NSManaged public func addToSubjects(_ value: NSSet)
    
    @objc(removeSubjects:)
    @NSManaged public func removeFromSubjects(_ value: NSSet)
}


// CollectionItems
extension Book {
    @objc(addCollectionItemsObject:)
    @NSManaged public func addToCollectionItems(_ value: CollectionItem)
    
    @objc(removeCollectionItemsObject:)
    @NSManaged public func removeFromCollectionItems(_ value: CollectionItem)
    
    @objc(addCollectionItems:)
    @NSManaged public func addToCollectionItems(_ value: NSSet)
    
    @objc(removeCollectionItems:)
    @NSManaged public func removeFromCollectionItems(_ value: NSSet)
}

extension Book {
    @objc static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Book> {
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.sortDescriptors = [NSSortDescriptor(key: "issued", ascending: true)]
        request.predicate = predicate
        return request
    }
    @objc static func fetchRequestNoPredicate() -> NSFetchRequest<Book> {
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.sortDescriptors = [NSSortDescriptor(key: "issued", ascending: true)]
        return request
    }
}
