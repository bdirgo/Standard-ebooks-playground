import SwiftUI

struct BrowseView: View {
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "itemCount", ascending: false),
    ])
    private var featuredCollections: FetchedResults<BookCollection>
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "booksCount", ascending: false),
    ])
    private var featuredAuthors: FetchedResults<BookAuthor>
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    var body: some View {
        
        List {
            
            FeaturedSections(
                featuredCollections: Array(featuredCollections.prefix(10).reversed()), 
                featuredAuthors: Array(featuredAuthors.prefix(10).reversed()))
                .listRowSeparator(.hidden)
            Spacer()
                .listRowSeparator(.hidden)
            NavigationLink(destination: List {
                BrowseList()
            }
                .navigationTitle("Browse Lists")
            ) {
                Label("Browse lists", systemImage: "list.bullet")
            }
            
        }
        .listStyle(.plain)
        .navigationTitle("Browse")
        
    }
}

struct FeaturedSections: View {
    var featuredCollections: [BookCollection]
    var featuredAuthors: [BookAuthor]
    var body: some View {
        Section {
            HorizontalFeaturedCollections(featuredCollections: featuredCollections)
        } header: { 
            Text("Featured Collections")
                .font(.title2)
        }
        Section { 
            HorizontalFeaturedAuthors(featuredBooks: featuredAuthors)
        } header: { 
            Text("Featured Authors")
                .font(.title2)
        }
    }
}

struct BrowseList: View {
    let collectionPredicate: NSPredicate = NSPredicate(format: "type CONTAINS[c] %@", "set")
    let seriesPredicate: NSPredicate = NSPredicate(format: "type CONTAINS[c] %@", "series")
    var body: some View {
        NavigationLink(destination: AllBooksView()) { 
            Label("All Books", systemImage: "character.book.closed.fill")
        }
        NavigationLink(destination: CollectionsView(predicate: collectionPredicate)) {
            Label("Collections", systemImage: "books.vertical.circle.fill")
        }
        NavigationLink(destination: CollectionsView(predicate: seriesPredicate, name: "Series")) {
            Label("Series", systemImage: "books.vertical.circle.fill")
        }
        Section("Subjects") {
            SubjectView()
        }
        Section("Categories") {
            CategoryView()
        }
    }
}

extension BrowseView {
    private func fetchBooks() async {
        isLoading = true
        do {
            try await booksProvider.fetchBooks()
        } catch {
            self.error = error as? SEError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}

struct AllBooksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @FetchRequest(sortDescriptors: BookSort.initial.descriptors, animation: .default) private var books: FetchedResults<Book>
    
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
                ForEach(Array(books), id:\.self) { book in
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
        }
            .toolbar { 
                SortSelectionView(selectedSortItem: $selectedSort, sorts: BookSort.sorts)
                    .onChange(of: selectedSort) { _ in
                        let request = books
                        request.sortDescriptors = selectedSort.descriptors
                    }
            }
            .navigationTitle("All Books")
    }
}

extension AllBooksView {
    var columns: [GridItem] {
        if sizeClass == .compact {
            return [GridItem(.adaptive(minimum: 125))]
        } else {
            return [GridItem(.adaptive(minimum: 240))]
        }
    }
    
    private func fetchBooks() async {
        isLoading = true
        do {
            try await booksProvider.fetchBooks()
        } catch {
            self.error = error as? SEError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
        Task {
            // TODO: tell detail page to stop "more for this author" from loading
            try await booksProvider.fetchGithubSearchResults()
        }
    }
}

struct AllBooksView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllBooksView()
        }
    }
}

struct HorizontalFeaturedCollections: View {
    var featuredCollections: [BookCollection]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 20) {
                ForEach(featuredCollections, id:\.name) { collection in
                    NavigationLink(destination:  CollectionList(collectionName: collection.name_)) { 
                        VStack {
                            if let book = collection.collectionItems_.first?.book {
                                BookThumbnailImage(thumbnailUrl: book.thumbnailUrl_, hasAudiobook: book.hasAudiobook)
                            } else {
                                Image(systemName: "book")
                                    .scaledToFit()
                                    .frame(width: 100, height: 150)
                            }
                            Text(collection.name_)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    minWidth: 100,
                                    maxWidth: 112.5
                                )
                                .lineLimit(3)
                                .font(.headline)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
            }
        }
    }
}

struct HorizontalFeaturedAuthors: View {
    var featuredBooks: [BookAuthor]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .top, spacing: 20) {
                ForEach(featuredBooks, id:\.self) { author in
                    NavigationLink(destination:  List {
                        BookList(books: author.books_)
                            .navigationTitle(author.name_)
                    }) { 
                        VStack {
                            if let book = author.books_.first {
                                BookThumbnailImage(thumbnailUrl: book.thumbnailUrl_, hasAudiobook: book.hasAudiobook)
                            } else {
                                Image(systemName: "book")
                                    .scaledToFit()
                                    .frame(width: 100, height: 150)
                            }
                            Text(author.name_)
                                .font(.headline)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
            }
        }
    }
}
