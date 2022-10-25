import SwiftUI
import CoreData

struct NewDetailPage: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var downloader = DownloadManager()
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    @FetchRequest private var bookDetails: FetchedResults<Book>
    
    init(book: Book) {
        self.book = book
        let request: NSFetchRequest<Book> = Book.fetchRequestNoPredicate()
        request.predicate = NSPredicate(format: "id = %@", book.id)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Book.issued, ascending: false)
        ]
        request.fetchLimit = 1
        request.relationshipKeyPathsForPrefetching = ["authors", "categories", "subjects", "collectionItems"] // relationships that we know will be traversed for this view 
        //        request.propertiesToFetch // tailor requests for each view 
        _bookDetails = FetchRequest(fetchRequest: request)
    }
    
    var book: Book
    var body: some View {
        ScrollView {
                LazyVStack {
                    if let book = bookDetails.first {
                        DetailPageTitle(book: book )
                        Divider()
                        AudioBook(book:book)
                        BookContentView(book: book, colorScheme: colorScheme)
                        Divider()
                        DetailPageLinks(book: book)
//                        I think this more section is breaking because the core data is updating in the background and can’t handle the ui updates. Need to find a way to stop more section from showing if the core data is updating
                        //if (!_viewContext) {
                            MoreForThisBook(book: book)
                                .padding(.bottom)
                        //}
                    }
                }
                .padding()
                .padding(.bottom)
        }
        .onAppear {
            if !book.didAddGithub {
                Task {
                    await fetchGithubOPF(for: book)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(book.title_)
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
        .environmentObject(downloader)
    }
}

extension NewDetailPage {
    private func fetchGithubOPF(for entry: Book) async {
        isLoading = true
        do {
            try await booksProvider.fetchGithubOPF(for: entry.githubSearchName, on: entry)
            
        } catch {
            self.error = error as? SEError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}

//class DetailPageViewModel: ObservableObject {
//    var viewContext = PersistenceController.shared.container.viewContext
//    @Published var moreByThisAuthor: [Book] = []
//    @Published var moreOfThisCategory: [Book] = []
//    @Published var moreCategoryName: String = ""
//    
//    func didAddBook(book: Book, _ didHe: Bool) {
//        book.didAdd = didHe
//        book.updatedAt = Date()
//        try? viewContext.save()
//    }
//    
//    func fetchMoreForThisBook(book: Book) {
//        let authorBooks = book.authors_.first?.books_ ?? []
//        if authorBooks.count > 1 {
//            moreByThisAuthor = authorBooks
//        }
//        let categories = book.categories_.first?.books_ ?? []
//        if categories.count > 1 {
//            moreCategoryName = book.categories_.first?.name_ ?? "Category"
//            moreOfThisCategory = categories
//        }
//    }
//}

struct SEShareLink: View {
    var book: Book
    var body: some View {
        Link("Link to Standard Ebooks", destination: URL(string: book.url)!)
    }
}
