//import SwiftUI
//import XMLCoder
//import CoreData
//
//class OldContentViewModel: ObservableObject {
//    var viewContext = PersistenceController.shared.container.viewContext
//    @Published var allBooks: [Book] = []
//    @Published var booksByCategory: [BookCategory] = []
//    @Published var booksBySubject: [BookSubject] = []
//    @Published var allCollections: [BookCollection] = []
//    @Published var searchText = ""
//    @Published var searchResults: [Book] = []
//    @Published var opdsSearchResults: [Book] = []
////    This breaks things
////    @Published var currentBook: Book = Book()
//    @Published var currentSubject: [BookSubject] = []
//    @Published var currentCategory: [BookCategory] = []
//    @Published var currentCollection: [CollectionItem] = []
//    @Published var currentAuthor: [BookAuthor] = []
//    @Published var newReleases: [Book] = []
//    @Published var forYouAuthor: [Book] = []
//    @Published var forYouCategory: [BookCategory] = []
//    @Published var allDownloaded: [Book] = []
//    @Published var allAdded: [Book] = []
//    @Published var loadingSubjects = true
////    I think this should be split up somehow. 
////    Not sure how to update, OPF has most of the data, but will take much longer to decode, and its not all of the data. 
////    OPDS has all the important information but not any of the good stuff like collections and word count. 
//    private var githubSearchResults: [Response] = [] 
//    
//    init() {
////        
//    }
//    func fetchNewReleases() {
//        let request = NSFetchRequest<Book>(entityName: "Book")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "issued", ascending: false)
//        ]
//        request.fetchLimit = 30
//        do {
//            newReleases = try self.viewContext.fetch(request)
//            if newReleases.first == nil {
//                print("first time setting new releases")
//                Task {
//                    try await fetchNewReleasesFromEndpoint()
//                }
//            } else if newReleases.first!.updatedAt_ < Date(timeIntervalSinceNow: -1 * 24 * 60 * 60) {
//                print("updating new releases")
//                Task {
//                    try await fetchNewReleasesFromEndpoint()
//                }
//            }
//            saveData()
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//    }
//    @available(iOS 15.0, *)
//    func fetchOpdsSearchResults(searchTerm: String) async 
//    throws {
//        let endpoints = OpdsEndpoints()
//        guard let url = URL(string: endpoints.search + searchTerm) else { return }
//        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
//        if let bookFeedData = try? XMLDecoder().decode(BookFeed.self, from: data) {
//            for book in bookFeedData.entries {
//                if let cdBook = fetchBook(id: book.id) {
//                    self.opdsSearchResults.append(cdBook)
//                }
//            }
//        }
//    }
//    func fetchAllAddedBooks() -> [Book]? {
//        let request = NSFetchRequest<Book>(entityName: "Book")
//        request.predicate = NSPredicate(format: "didAdd = true")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "updatedAt", ascending: false)
//        ]
//        do {
//            let added = try self.viewContext.fetch(request)
//            allAdded = added
//            return added
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func fetchAllDownloadedBooks() -> [Book]? {
//        let request = NSFetchRequest<Book>(entityName: "Book")
//        request.predicate = NSPredicate(format: "didDownload = true")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "updatedAt", ascending: false)
//        ]
//        do {
//            let downloaded = try self.viewContext.fetch(request)
//            allDownloaded = downloaded
//            return downloaded
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func fetchForYou() {
////        let books = fetchAllDownloadedBooks() ?? []
//        let books = fetchAllAddedBooks() ?? []
//        if let book = books.first {
//            let authorBooks = fetchMoreByThisAuthor(author: book.firstAuthor) ?? []
//            if authorBooks.count > 1 {
//                forYouAuthor = authorBooks
//            } else {
//                forYouAuthor = []
//            }
//        }
//        var allCategories: [BookCategory] = []
//        for b in books {
//            if b.categories_.count > 0 {
//                for category in b.categories_ {
//                    allCategories.append(category)
//                }
//            } else {
//                allCategories = []
//            }
//        }
//        let categories = allCategories.sorted {
//            Int(truncating: $0.booksCount) > Int(truncating: $1.booksCount)
//        }
//        forYouCategory = categories
//    }
//    func fetchForThisBook(bookId: String) {
//        if let book = fetchBook(id: bookId) {
//            let authorBooks = fetchMoreByThisAuthor(author: book.firstAuthor) ?? []
//            if authorBooks.count > 1 {
//                forYouAuthor = authorBooks
//            } else {
//                forYouAuthor = []
//            }
//            var allCategories: [BookCategory] = []
//            if book.categories_.count > 0 {
//                for category in book.categories_ {
//                    allCategories.append(category)
//                }
//            } else {
//                allCategories = []
//            }
//            let categories = allCategories.sorted {
//                Int(truncating: $0.booksCount) > Int(truncating: $1.booksCount)
//            }
//            forYouCategory = categories
//        }
//    }
//    func fetchMoreByThisAuthor(author: String) -> [Book]? {
//        let request = NSFetchRequest<BookAuthor>(entityName: "BookAuthor")
//        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", author)
//        do {
//            let authors = try self.viewContext.fetch(request) 
//            var allBooks: [Book] = []
//            for author in authors {
//                for book in author.books_ {
//                    allBooks.append(book)
//                }
//            }
//            return allBooks
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func didAddBook(book: Book, _ didHe: Bool) {
//        book.didAdd = didHe
//        book.updatedAt = Date()
//        saveData()
//    }
//    
//    func didDownloadBook(book: Book) {
//        book.didDownload = true
//        book.updatedAt = Date()
//        saveData()
//    }
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
//    func fetchBooks() {
//        let request = NSFetchRequest<Book>(entityName: "Book")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "author", ascending: false)
//        ]
//        do {
//            allBooks = try self.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching \(error)")
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
//    func fetchBookCollection(name: String) -> BookCollection? {
//        let request = BookCollection.fetchRequest(NSPredicate(format: "name = %@", name))
//        do {
//            let bookCollections = try self.viewContext.fetch(request)
//            return bookCollections.first
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func updateBookCollection(bookCollection: BookCollection, collection: SECollection) {
//        bookCollection.name = collection.title
//        bookCollection.type = collection.collectionType
//        bookCollection.updatedAt = Date()
//    }
//    func fetchCollectionItem(id: String) -> CollectionItem? {
//        let request = CollectionItem.fetchRequest(NSPredicate(format: "bookId = %@", id))
//        do {
//            let items = try self.viewContext.fetch(request)
//            return items.first
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func updateCollectionItem(collectionItem: CollectionItem, collection: SECollection, book: Book) {
//        collectionItem.name = collection.title
//        collectionItem.position = collection.groupPosition as NSNumber?
//        collectionItem.rank = collection.index as NSNumber?
//        collectionItem.book = book
//        collectionItem.updatedAt = Date()
//    }
//    func fetchBook(id: String) -> Book? {
//        let request = NSFetchRequest<Book>(entityName: "Book")
//        request.predicate = NSPredicate(format: "url = %@", id)
//        do {
//            let books = try self.viewContext.fetch(request)
//            if let book = books.first {
////                currentBook = book
//                return book
//            } else {
//                return nil
//            }
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func addBook(id: String) {
//        let newBook = Book(context: self.viewContext)
//        newBook.url = id
//    }
//    func updateBook(book: Book, with entry: FeedEntry) {
//        book.url = entry.id
//        book.title = entry.title
//        book.summary = entry.summary
//        book.ePubUrl = entry.epubUrl?.absoluteString
//        book.coverUrl = entry.imageUrl?.absoluteString
//        book.thumbnailUrl = entry.thumbnailUrl?.absoluteString
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let date0 = dateFormatter.date(from:entry.issued ) ?? Date() 
//        book.issued = date0
//        book.updatedAt = Date()
//    }
//    func fetchBooksForAuthor(name: String) -> [Book]? {
//        let request = BookAuthor.fetchRequest(NSPredicate(format: "name = %@", name))
//        do {
//            let bookAuthors = try self.viewContext.fetch(request)
//            currentAuthor = bookAuthors
//            if let auth = bookAuthors.first {
//                return auth.books_
//            } else {
//                return nil
//            }
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func fetchAuthor(name: String) -> BookAuthor? {
//        let request = BookAuthor.fetchRequest(NSPredicate(format: "name = %@", name))
//        do {
//            let bookAuthors = try self.viewContext.fetch(request)
//            if let auth = bookAuthors.first {
//                return auth
//            } else {
//                return nil
//            }
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func updateAuthorFor(book: Book, author person: BookAuthor, with author: Author) {
//        person.name = author.name
//        person.uri = author.uri ?? ""
//        person.addToBooks(book)
//        person.updatedAt = Date()
//    }
//    func fetchCategory(name: String) -> BookCategory? {
//        let request = BookCategory.fetchRequest(NSPredicate(format: "name = %@", name))
//        do {
//            let bookCategories = try self.viewContext.fetch(request)
//            if let cat = bookCategories.first {
//                return cat
//            } else {
//                return nil
//            }
//        } catch let error {
//            print("Error fetching \(error)")
//            return nil
//        }
//    }
//    func updateCategoryFor(book: Book, category cat: BookCategory, with category: Category) {
//        cat.name = category.term
//        cat.addToBooks(book)
//        cat.updatedAt = Date()
//    }
//    func saveData() {
//        if self.viewContext.hasChanges {
//            do {
//                try self.viewContext.save()
//            } catch let error {
//                print("error saving \(error)")
//            }
//        }
//    }
//    func fetchAllCollections() {
//        let request = NSFetchRequest<BookCollection>(entityName: "BookCollection")
//        request.sortDescriptors = [NSSortDescriptor(key: "itemCount", ascending: false)]
//        do {
//            allCollections = try self.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//    }
//    func fetchBooksForCollection(name: String) {
//        let request = NSFetchRequest<BookCollection>(entityName: "BookCollection")
//        request.predicate = NSPredicate(format: "name = %@", name)
//        do {
//            let bookCollections = try self.viewContext.fetch(request)
//            if let collection = bookCollections.first {
//                currentCollection = collection.collectionItems_
//            }
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//        
//    }
//    func fetchBooksForSubject(subject: AllSubjects) {
//        if subject.isCustom {
//            fetchBooksForCustomSubject(name: subject.name)
//        } else {
//            fetchBooksForSubject(name: subject.name)
//        }
//    }
//    func fetchBooksForSubject(name: String) {
//        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
//        request.predicate = NSPredicate(format: "name = %@", name)
//        do {
//            currentSubject = try self.viewContext.fetch(request)
//            if currentSubject.first == nil {
//                print("first time downloading \(name)")
//                Task {
//                    try await fetchSubjectFromEndpoint(subjectName: name)
//                }
//                saveData()
//            } else if currentSubject.first!.updatedAt_ < Date(timeIntervalSinceNow: -1 * 24 * 60 * 60) {
//                print("updating subject \(name)")
//                Task {try await fetchSubjectFromEndpoint(subjectName: name)}
//                saveData()
//            }
//            loadingSubjects = false
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//        
//    }
//    func fetchBooksForCustomSubject(name: String) {
//        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
//        request.predicate = NSPredicate(format: "name = %@", name)
//        do {
//            currentSubject = try self.viewContext.fetch(request)
//            if currentSubject.first == nil {
//                print("first time downloading \(name)")
//                Task { @MainActor in
//                    try await fetchOpdsSearchResults(searchTerm: name)
//                    let subject = BookSubject(context: self.viewContext)
//                    subject.name = name 
//                    subject.updatedAt = Date()
//                    for book in opdsSearchResults {
//                        subject.addToBooks(book)
//                    }
//                }
//                saveData()
////            } else if currentSubject.first!.updatedAt_ < Date(timeIntervalSinceNow: -1 * 24 * 60 * 60) {
////                print("updating subject \(name)")
////                Task {try await fetchSubjectFromEndpoint(subjectName: name)}
////                saveData()
//            }
//            loadingSubjects = false
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//    }
//    func fetchBooksBySubject() {
//        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "booksCount", ascending: false)
//        ]
//        do {
//            booksBySubject = try self.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//    }
//    
//    func fetchBooksForCategory(name: String) {
//        let request = NSFetchRequest<BookCategory>(entityName: "BookCategory")
//        request.predicate = NSPredicate(format: "name = %@", name)
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "booksCount", ascending: false)
//        ]
//        do {
//            currentCategory = try self.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//    }
//    func fetchBooksByCategory() {
//        let request = NSFetchRequest<BookCategory>(entityName: "BookCategory")
//        request.sortDescriptors = [
//            NSSortDescriptor(key: "booksCount", ascending: false)
//        ]
//        do {
//            booksByCategory = try self.viewContext.fetch(request)
//        } catch let error {
//            print("Error fetching \(error)")
//        }
//    }
//    
//    let allSubjects: [AllSubjects] = [
//        AllSubjects(name: "Adventure", symbolName: "globe"),
//        AllSubjects(name: "Autobiography", symbolName: "figure.walk.circle"),
//        AllSubjects(name: "Biography", symbolName: "figure.walk"),
//        AllSubjects(name: "Childrens", symbolName: "circle.square.fill"), 
//        AllSubjects(name: "Comedy", symbolName: "mustache.fill"),
//        AllSubjects(name: "Drama", symbolName: "theatermasks.fill"),
//        AllSubjects(name: "Fantasy", symbolName: "sparkles"),
//        AllSubjects(name: "Fiction", symbolName: "books.vertical.fill"),
//        AllSubjects(name: "Horror", symbolName: "house.fill"),
//        AllSubjects(name: "Memoir", symbolName: "doc.append"),
//        AllSubjects(name: "Mystery", symbolName: "magnifyingglass"),
//        AllSubjects(name: "Nonfiction", symbolName: "newspaper.fill"),
//        AllSubjects(name: "Philosophy", symbolName: "applescript.fill"),
//        AllSubjects(name: "Poetry", symbolName: "hands.sparkles.fill"),
//        AllSubjects(name: "Satire", symbolName: "eyeglasses"),
//        AllSubjects(name: "Science-Fiction", symbolName: "applewatch"),
//        AllSubjects(name: "Shorts", symbolName: "magazine.fill"),
//        AllSubjects(name: "Spirituality", symbolName: "s.circle.fill"),
//        AllSubjects(name: "Travel", symbolName: "ferry.fill"),
//        AllSubjects(name: "History", symbolName: "h.circle.fill", isCustom: true),
//    ]
//    enum FetchError: Error {
//        case badRequest
//        case badJSON
//    }
//    
//    @available(iOS 15.0, *)
//    func fetchSubjectFromEndpoint(subjectName: String) async
//    throws {
//        let endpoints = OpdsEndpoints() 
//        guard let url = URL(string: endpoints.subjects + subjectName.lowercased()) else { return }
//        
//        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
//        
//        Task { @MainActor in
//            let contentDecoder = ContentParser(xmlData: data)
//            if let bookFeedData = try? XMLDecoder().decode(BookFeed.self, from: data) {
//                let subject = BookSubject(context: self.viewContext)
//                subject.name = subjectName 
//                subject.updatedAt = Date()
//                for entry in bookFeedData.entries {
////                    if book exists update it
//                    if var book = fetchBook(id: entry.id) {
//                        updateBook(book: book, with: entry)
//                        let entryCategories = entry.categories
//                        entryCategories?.forEach({ cat in
//                            if let cdCategory = fetchCategory(name: cat.term) {
//                                updateCategoryFor(book: book, category: cdCategory, with: cat)
//                            } else {
//                                let newCategory = BookCategory(context: self.viewContext)
//                                updateCategoryFor(book: book, category: newCategory, with: cat)
//                            }
//                        })
//                        let entryAuthors = entry.authors
//                        entryAuthors.forEach({ person in
//                            if let cdAuthor = fetchAuthor(name: person.name) {
//                                updateAuthorFor(book: book, author: cdAuthor, with: person)
//                            } else {
//                                let newAuthor = BookAuthor(context: self.viewContext)
//                                updateAuthorFor(book: book, author: newAuthor, with: person)
//                            }
//                        })
//                        subject.addToBooks(book)
//                        contentDecoder.mergeContentwith(book: &book)
//                    } else {
////                        else create it
//                        var book = Book(context: self.viewContext)
//                        updateBook(book: book, with: entry)
//                        let entryCategories = entry.categories
//                        entryCategories?.forEach({ cat in
//                            if let cdCategory = fetchCategory(name: cat.term) {
//                                updateCategoryFor(book: book, category: cdCategory, with: cat)
//                            } else {
//                                let newCategory = BookCategory(context: self.viewContext)
//                                updateCategoryFor(book: book, category: newCategory, with: cat)
//                            }
//                        })
//                        let entryAuthors = entry.authors
//                        entryAuthors.forEach({ person in
//                            if let cdAuthor = fetchAuthor(name: person.name) {
//                                updateAuthorFor(book: book, author: cdAuthor, with: person)
//                            } else {
//                                let newAuthor = BookAuthor(context: self.viewContext)
//                                updateAuthorFor(book: book, author: newAuthor, with: person)
//                            }
//                        })
//                        subject.addToBooks(book)
//                        contentDecoder.mergeContentwith(book: &book)
//                    }
//                }
//            }
//        }
//    }
//    
//    @available(iOS 15.0, *)
//    func fetchNewReleasesFromEndpoint() async
//    throws {
//        let endpoints = OpdsEndpoints() 
//        guard let url = URL(string: endpoints.new) else { return }
//        
//        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
//        
//        Task { @MainActor in
//            let contentDecoder = ContentParser(xmlData: data)
//            if let bookFeedData = try? XMLDecoder().decode(BookFeed.self, from: data) {
//                for entry in bookFeedData.entries {
//                    let ifBook = fetchBook(id: entry.id)
//                    if ifBook != nil {
//                        newReleases.append(ifBook!)
//                    } else {
//                        // Create a book
//                        var book = Book(context: self.viewContext)
//                        updateBook(book: book, with: entry)
//                        let entryCategories = entry.categories
//                        entryCategories?.forEach({ cat in
//                            if let cdCategory = fetchCategory(name: cat.term) {
//                                updateCategoryFor(book: book, category: cdCategory, with: cat)
//                            } else {
//                                let newCategory = BookCategory(context: self.viewContext)
//                                updateCategoryFor(book: book, category: newCategory, with: cat)
//                            }
//                        })
//                        let entryAuthors = entry.authors
//                        entryAuthors.forEach({ person in
//                            if let cdAuthor = fetchAuthor(name: person.name) {
//                                updateAuthorFor(book: book, author: cdAuthor, with: person)
//                            } else {
//                                let newAuthor = BookAuthor(context: self.viewContext)
//                                updateAuthorFor(book: book, author: newAuthor, with: person)
//                            }
//                        })
//                        // Subject may not be on this object
//                        contentDecoder.mergeContentwith(book: &book)
//                        newReleases.append(book)
//                    }
//                }
//            }
//        }
//    }
//    struct GithubEnpoints {
//        let searchForCollections = "https://api.github.com/search/code?q=belongs-to-collection+in:file+filename:content+org:standardebooks"
//        let rawContent = "https://raw.githubusercontent.com"
//    }
//    func createEntryIdFromGithub(opfUrl: String) -> String? {
//        let standardURL = URL(string: OpdsEndpoints().index)!
//        let githubURL = URL(string: opfUrl)!
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = standardURL.host
//        if let name = githubURL.pathComponents.first(where: { str in
//            str.contains("_")
//        }){
//            let underscores = name.compactMap { char in
//                char == Character("_")
//            }.filter { k in
//                k == true
//            }
//            var newName: String = ""
//            if underscores.count > 1 {
//                // If there are more then one author/translator then the url with have two or more underbars
//                var firstScore: String = ""
//                if let range = name.range(of: "_") {
//                    firstScore = name.replacingCharacters(in: range, with: "/")
//                }
//                if let range = firstScore.range(of: "_") {
//                    newName = firstScore.replacingCharacters(in: range, with: "/")
//                }
//            } else {
//                newName = name.replacingOccurrences(of: "_", with: "/")
//            }
//            components.path = "/ebooks/" + newName
////            print(components.string ?? "nil id string")
//            return components.string
//        }
//        return nil
//    }
//    func createRawGithubURL(url: String) -> String {
//        let standardURL = URL(string: GithubEnpoints().rawContent)!
//        let githubURL = URL(string: url)!
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host = standardURL.host
//        components.path = githubURL.path
//        let componentsString = components.string ?? ""
//        return componentsString.replacingOccurrences(of: "/blob", with: "")
//    }
//    @available(iOS 15.0, *)
//    func fetchOpfAndMergeBook(forOpf id: String, in entryId: String) async
//    throws {
//        guard let url = URL(string: id) else { return }
//        
//        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
//        
//        Task { @MainActor in
//            if let cdBook = fetchBook(id: entryId) {
//                let opfDecoder = OPFParser(xmlData: data)
//                let collections = opfDecoder.collections
//                for collection in collections {
////                    print("\(cdBook.title_) for SE collection \(collection)")
//                    if let title = collection.title {
//                        if let bookCollection = fetchBookCollection(name: title) {
////                            print("\(cdBook.title_) for SE collection \(collection) bookCollection \(bookCollection)")
//                            if let item = fetchCollectionItem(id: cdBook.url) {
////                                print("item and collection already exist")
////                                item.book = cdBook
//                                cdBook.addToCollectionItems(item)
//                                bookCollection.addToCollectionItems(item)
//                                saveData()
//                                print("saved \(cdBook) for bookCollection \(bookCollection) on item \(item)")
//                            } else {
//                                let newCollectionItem = CollectionItem(context: self.viewContext)
//                                newCollectionItem.name = title
//                                newCollectionItem.position = collection.groupPosition as NSNumber?
//                                newCollectionItem.rank = collection.index as NSNumber?
//                                cdBook.addToCollectionItems(newCollectionItem)
//                                newCollectionItem.updatedAt = Date()
//                                bookCollection.addToCollectionItems(newCollectionItem)
//                                saveData()
//                                print("saved \(cdBook) for bookCollection \(bookCollection) on item \(newCollectionItem)")
//                            }
//                        } else {
//                            let newBookCollection = BookCollection(context: self.viewContext)
//                            newBookCollection.name = title
//                            newBookCollection.type = collection.collectionType
//                            newBookCollection.updatedAt = Date()
//                            saveData()
////                            print("saved \(cdBook.title_) for SE collection \(collection) bookCollection \(newBookCollection)")
//                            if let item = fetchCollectionItem(id: cdBook.url) {
//                                cdBook.addToCollectionItems(item)
//                                newBookCollection.addToCollectionItems(item)
//                                saveData()
//                                print("saved \(cdBook) for bookCollection \(newBookCollection) on item \(item)")
//                            } else {
//                                let newCollectionItem = CollectionItem(context: self.viewContext)
//                                newCollectionItem.name = title
//                                newCollectionItem.position = collection.groupPosition as NSNumber?
//                                newCollectionItem.rank = collection.index as NSNumber?
//                                cdBook.addToCollectionItems(newCollectionItem)
//                                newCollectionItem.updatedAt = Date()
//                                newBookCollection.addToCollectionItems(newCollectionItem)
//                                saveData()
//                                print("saved \(cdBook) for bookCollection \(newBookCollection) on item \(newCollectionItem)")
//                            }
//                        }
//                        saveData()
////                        print("SAVED SE collection \(collection)")
//                    } else {
//                        print("collection title is nil \(collection)")
//                    }
//                }
//            }
//        }
//    }
//    func fetchAllGithubCollections() async {
////        TODO: better progress bar, use totalCount
//        try? await fetchGithubSearchResults()
//        let searchResults = githubSearchResults.flatMap { res in
//            res.items
//        }
//        for item in searchResults {
//            let opfUrl = createRawGithubURL(url: item.htmlUrl)
//            if let entryId = createEntryIdFromGithub(opfUrl: opfUrl) {
//                try? await fetchOpfAndMergeBook(forOpf: opfUrl, in: entryId)
//            }
//        }
//        saveData()
//    }
//    @available(iOS 15.0, *)
//    func fetchGithubSearchResults(pageNum: Int = 1, resultLimit: Int = 80) async
//    throws {
//        let urlParams = "&per_page=\(resultLimit)&page=\(pageNum)"
//        let endpoints = GithubEnpoints() 
//        let urlString = endpoints.searchForCollections + urlParams
//        print(urlString)
//        guard let url = URL(string: urlString) else { return }
//        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw FetchError.badRequest }
//        let task = Task { () -> Response? in
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            if let decodedResponse = try? decoder.decode(Response.self, from: data) {
////                print(decodedResponse.totalCount)
////                print(pageNum)
////                print(decodedResponse.total_count - (resultLimit * pageNum))
//                if (decodedResponse.totalCount - (resultLimit * pageNum) >= 1) {
//                    try await fetchGithubSearchResults(pageNum: pageNum + 1, resultLimit: resultLimit)
//                }
//                return decodedResponse
//            }
//            return nil
//        }
//        let result = await task.result
//        do {
//            if let res = try result.get() {
////                print(res)
//                self.githubSearchResults.append(res)
//            }
//        } catch {
//            print("github fetch error")
//        }
//    }
//}
