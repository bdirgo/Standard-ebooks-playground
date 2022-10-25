import CoreData
import SwiftUI

@objc(LibrivoxBook)
class LibrivoxBook: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var language: String?
    @NSManaged var url: String?
    @NSManaged var totalTimeSecs: NSNumber?
    @NSManaged var firstAuthor: String?
    @NSManaged var authorDOB: String?
    @NSManaged var authorDOD: String?
    
    @NSManaged var book: Book?
}

extension LibrivoxBook: Identifiable {
    
}

extension LibrivoxBook {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<LibrivoxBook> {
        let request = NSFetchRequest<LibrivoxBook>(entityName: "LibrivoxBook")
//        request.sortDescriptors = [NSSortDescriptor(key: "booksCount", ascending: true)]
        request.predicate = predicate
        return request
    }
}

