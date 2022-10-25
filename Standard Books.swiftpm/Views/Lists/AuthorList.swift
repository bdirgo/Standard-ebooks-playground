import SwiftUI
import CoreData

struct AuthorList: View {
    @StateObject var viewModel = AuthorListViewModel()
    var authorName: String
    var body: some View {
        VStack {
            List {
                BookList(books: viewModel.author)
            }
            .onAppear { let _ = viewModel.fetchAuthorFromCoreData(name: authorName) }
            .navigationTitle(authorName)
        }
    }
}

class AuthorListViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var author: [Book] = []
    
    func fetchAuthorFromCoreData(name: String) {
        let request = NSFetchRequest<BookAuthor>(entityName: "BookAuthor")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "issued", ascending: false)
//        ]
        request.predicate = NSPredicate(format: "name = %@", name)
        request.fetchBatchSize = 10 // might not be needed
        request.relationshipKeyPathsForPrefetching = ["books"]  // relationships that we know will be traversed for this view
        //        request.propertiesToFetch // tailor requests for each view 
        do {
            let authors = try self.viewContext.fetch(request)
            if let author = authors.first {
                self.author = author.books_
            }
        } catch let error {
            print("Error fetching all books \(error)")
        }
    }
}
