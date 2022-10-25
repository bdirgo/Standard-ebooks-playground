import SwiftUI
import XMLCoder
import CoreData

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var isLoadingResults: Bool = false
    
    var body: some View {
        List {
            if isLoadingResults {
                ProgressView()
            } else {
                if viewModel.opdsSearchResults.count > 0 {
                    BookList(books: viewModel.opdsSearchResults)
                }
//                if viewModel.searchText.count > 0 && viewModel.opdsSearchResults.count == 0 {
//                    Section("Suggested") {
//                        BookList(books: viewModel.opdsSearchResults)
//                    }
//                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Search")
        .onSubmit(of: .search) { // search results
            isLoadingResults = true
            print(viewModel.searchText)
            Task {
                try await viewModel.fetchOpdsSearchResults(searchTerm: viewModel.searchText)
                isLoadingResults = false
            }
        }
        //.onChange(of: viewModel.searchText) { _ in viewModel.submitCurrentSearchQuery() } // search suggestions
    }    
}

class SearchViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var searchText = ""
    @Published var searchResults: [Book] = []
    @Published var opdsSearchResults: [Book] = []
    
//    func submitCurrentSearchQuery() {
//        var resultSet: Set<Book> = []
//        for book in searchBook(name: searchText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? [] {
//            resultSet.insert(book)
//        }
//        for book in searchAuthor(name: searchText.trimmingCharacters(in: .whitespacesAndNewlines)) ?? [] {
//            resultSet.insert(book)
//        }
//        searchResults = resultSet.sorted {
//            $0.title_ < $1.title_
//        }
//    }
//    func searchBook(name: String) -> [Book]? {
//        let request = NSFetchRequest<Book>(entityName: "Book")
//        request.predicate = NSPredicate(format: "title CONTAINS[c] %@", name)
//        do {
//            return try self.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func searchAuthor(name: String) -> [Book]? {
//        let request = NSFetchRequest<BookAuthor>(entityName: "BookAuthor")
//        request.predicate = NSPredicate(format: "name CONTAINS[c] %@", name)
//        do {
//            let bookAuthors = try self.viewContext.fetch(request)
//            var arrOfBooks: [Book] = []
//            for author in bookAuthors {
//                for book in author.books_ {
//                    arrOfBooks.append(book)
//                }
//            }
//            return arrOfBooks
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
    
    @available(iOS 15.0, *)
    func fetchOpdsSearchResults(searchTerm: String) async throws {
        let endpoints = OpdsEndpoints()
        let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        guard let url = URL(string: endpoints.search + encodedSearchTerm) else { return }
        print(url)
        
        var request = URLRequest(url: url)
        request.addValue("VockV3fu1c7vBvaG7A4oMALa9WIrPekx8jeH5HeBzuxir2X6NcAE5w==", forHTTPHeaderField: "x-functions-key")
        request.addValue("Basic YmlvdGFfdGlwc3Rlcl8wY0BpY2xvdWQuY29tOg==", forHTTPHeaderField: "Authorization")
        request.addValue("sessionid=a701da9f-cddc-4c5b-8587-1f379fca968e", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw SEError.missingData }
        if let bookFeedData = try? XMLDecoder().decode(BookFeed.self, from: data) {
            for book in bookFeedData.entries {
                if let cdBook = try await fetchBook(id: book.id) {
                    self.opdsSearchResults.append(cdBook)
                }
            }
        }
        func fetchBook(id: String) async throws -> Book? {
            let taskContext = PersistenceController.shared.newTaskContext()
            // Add name and author to identify source of persistent history changes.
            taskContext.name = "importContext"
            taskContext.transactionAuthor = "fetchOpdsSearchResults"
            
            return try await taskContext.perform {
                let request = NSFetchRequest<Book>(entityName: "Book")
                request.predicate = NSPredicate(format: "id = %@", id)
                let books = try taskContext.fetch(request)
                if let book = books.first {
                    return book
                }
                return nil
            }
        }
    }
}
