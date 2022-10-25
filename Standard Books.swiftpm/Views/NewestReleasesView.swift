import SwiftUI
import CoreData

struct NewestReleasesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @FetchRequest(sortDescriptors: BookSort.initial.descriptors, animation: .default) private var books: FetchedResults<Book>
    
//    @State private var newest: Bool = true
    @State private var selectedSort = BookSort.initial
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    
    var body: some View {
            ScrollView {
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                LazyVGrid(columns: columns) {
                    ForEach(Array(books.prefix(30)), id:\.self) { book in
                        if isLoading {
                            BookThumbnailImage(thumbnailUrl: book.thumbnailUrl_, hasAudiobook: book.hasAudiobook)
                        } else {
                            NavigationLink(destination: NewDetailPage(book: book)) {
                                BookThumbnailImage(thumbnailUrl: book.thumbnailUrl_, hasAudiobook: book.hasAudiobook)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack {
                            RefreshButton {
                                Task { 
                                    await fetchBooks()
                                }
                            }
                            .disabled(isLoading)
                        }
                    }
                }
            }
            .navigationTitle("New Releases")
    }
}

extension NewestReleasesView {
    var columns: [GridItem] {
        if sizeClass == .compact {
            return [GridItem(.adaptive(minimum: 150))]
        } else {
            return [GridItem(.adaptive(minimum: 240))]
        }
    }
    
    private func fetchBooks() async {
        isLoading = true
        do {
            try await booksProvider.fetchBooks()
//            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? SEError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
        Task {
//            TODO: tell detail page to stop more for this author from loading
            try await booksProvider.fetchGithubSearchResults()
        }
    }
}
