import SwiftUI
import CoreData
import XMLCoder

struct OpdsEndpoints {
    let index = "https://standardebooks.org"
    let subjects = "https://standardebooks.org/opds/subjects/"
    let new = "https://standardebooks.org/opds/new-releases/"
    let all = "https://standardebooks.org/opds/all/"
    let search = "https://standardebooks.org/opds/all?query="
}

class PersistenceController {
    let allSubjects: [AllSubjects] = [
        AllSubjects(name: "Adventure", symbolName: "globe"),
        AllSubjects(name: "Autobiography", symbolName: "figure.walk.circle"),
        AllSubjects(name: "Biography", symbolName: "figure.walk"),
        AllSubjects(name: "Childrens", symbolName: "circle.square.fill"), 
        AllSubjects(name: "Comedy", symbolName: "mustache.fill"),
        AllSubjects(name: "Drama", symbolName: "theatermasks.fill"),
        AllSubjects(name: "Fantasy", symbolName: "sparkles"),
        AllSubjects(name: "Fiction", symbolName: "books.vertical.fill"),
        AllSubjects(name: "History", symbolName: "h.circle.fill", isCustom: true),
        AllSubjects(name: "Horror", symbolName: "house.fill"),
        AllSubjects(name: "Memoir", symbolName: "doc.append"),
        AllSubjects(name: "Mystery", symbolName: "magnifyingglass"),
        AllSubjects(name: "Nonfiction", symbolName: "newspaper.fill"),
        AllSubjects(name: "Philosophy", symbolName: "applescript.fill"),
        AllSubjects(name: "Poetry", symbolName: "hands.sparkles.fill"),
        AllSubjects(name: "Political", symbolName: "scroll.fill", isCustom: true),
        AllSubjects(name: "Satire", symbolName: "eyeglasses"),
        AllSubjects(name: "Science-Fiction", symbolName: "moon.stars.fill"),
        AllSubjects(name: "Shorts", symbolName: "magazine.fill"),
        AllSubjects(name: "Spirituality", symbolName: "s.circle.fill"),
        AllSubjects(name: "Travel", symbolName: "ferry.fill"),
        AllSubjects(name: "War", symbolName: "w.circle.fill", isCustom: true)
    ]
    @State var isLoading: Bool = false
    private let inMemory: Bool
    // A singleton for our entire app to use
    static let shared = PersistenceController()
    // Storage for Core Data
    let container: NSPersistentContainer
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
//    Create entities
        let book = NSEntityDescription()
        book.name = "Book"
        book.managedObjectClassName = "Book"
        let author = NSEntityDescription()
        author.name = "BookAuthor"
        author.managedObjectClassName = "BookAuthor"
        let subject = NSEntityDescription()
        subject.name = "BookSubject"
        subject.managedObjectClassName = "BookSubject"
        let category = NSEntityDescription()
        category.name = "BookCategory"
        category.managedObjectClassName = "BookCategory"
        let collection = NSEntityDescription()
        collection.name = "BookCollection"
        collection.managedObjectClassName = "BookCollection"
        let collectionItem = NSEntityDescription()
        collectionItem.name = "CollectionItem"
        collectionItem.managedObjectClassName = "CollectionItem"
        let audiobook = NSEntityDescription()
        audiobook.name = "LibrivoxBook"
        audiobook.managedObjectClassName = "LibrivoxBook"
        
//        Create entities Attributes
//        Book
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.isOptional = false
        idAttribute.type = .string
        book.properties.append(idAttribute)
        let urlAttribute = NSAttributeDescription()
        urlAttribute.name = "url"
        urlAttribute.isOptional = false
        urlAttribute.type = .string
        book.properties.append(urlAttribute)
        let titleAttribute = NSAttributeDescription()
        titleAttribute.name = "title"
        titleAttribute.type = .string
        book.properties.append(titleAttribute)
        let summaryAttribute = NSAttributeDescription()
        summaryAttribute.name = "summary"
        summaryAttribute.type = .string
        book.properties.append(summaryAttribute)
        let languageAtt = NSAttributeDescription()
        languageAtt.name = "language"
        languageAtt.type = .string
        book.properties.append(languageAtt)
        let contentAttribute = NSAttributeDescription()
        contentAttribute.name = "content"
        contentAttribute.type = .string
        book.properties.append(contentAttribute)
        let coverUrlAttribute = NSAttributeDescription()
        coverUrlAttribute.name = "coverUrl"
        coverUrlAttribute.type = .string
        book.properties.append(coverUrlAttribute)
        let thumbnailUrlAttribute = NSAttributeDescription()
        thumbnailUrlAttribute.name = "thumbnailUrl"
        thumbnailUrlAttribute.type = .string
        book.properties.append(thumbnailUrlAttribute)
        let ePubUrlAttribute = NSAttributeDescription()
        ePubUrlAttribute.name = "ePubUrl"
        ePubUrlAttribute.type = .string
        book.properties.append(ePubUrlAttribute)
        let issuedAttribute = NSAttributeDescription()
        issuedAttribute.name = "issued"
        issuedAttribute.type = .date
        book.properties.append(issuedAttribute)
        let bookUpdateAttribute = NSAttributeDescription()
        bookUpdateAttribute.name = "updatedAt"
        bookUpdateAttribute.type = .date
        book.properties.append(bookUpdateAttribute)
        let bookDidDownloadAttribute = NSAttributeDescription()
        bookDidDownloadAttribute.name = "didDownload"
        bookDidDownloadAttribute.type = .boolean
        book.properties.append(bookDidDownloadAttribute)
        let bookDidAddGithubAttribute = NSAttributeDescription()
        bookDidAddGithubAttribute.name = "didAddGithub"
        bookDidAddGithubAttribute.type = .boolean
        book.properties.append(bookDidAddGithubAttribute)
        let bookDidAddAttribute = NSAttributeDescription()
        bookDidAddAttribute.name = "didAdd"
        bookDidAddAttribute.type = .boolean
        book.properties.append(bookDidAddAttribute)
        let wikipediaAttribute = NSAttributeDescription()
        wikipediaAttribute.name = "wikipedia"
        wikipediaAttribute.type = .string
        book.properties.append(wikipediaAttribute)
        let wordCountAttribute = NSAttributeDescription()
        wordCountAttribute.name = "wordCount"
        wordCountAttribute.type = .integer64
        book.properties.append(wordCountAttribute)
        let readingEaseAttribute = NSAttributeDescription()
        readingEaseAttribute.name = "readingEase"
        readingEaseAttribute.type = .double
        book.properties.append(readingEaseAttribute)
        let epubLengthAttribute = NSAttributeDescription()
        epubLengthAttribute.name = "ePubLength"
        epubLengthAttribute.type = .integer64
        book.properties.append(epubLengthAttribute)
        
        let audiobookTitle = NSAttributeDescription()
        audiobookTitle.name = "title"
        audiobookTitle.type = .string
        audiobook.properties.append(audiobookTitle)
        let audiobooklanguage = NSAttributeDescription()
        audiobooklanguage.name = "language"
        audiobooklanguage.type = .string
        audiobook.properties.append(audiobooklanguage)
        let audiobookurl = NSAttributeDescription()
        audiobookurl.name = "url"
        audiobookurl.type = .string
        audiobook.properties.append(audiobookurl)
        let audiobookfirstAuthor = NSAttributeDescription()
        audiobookfirstAuthor.name = "firstAuthor"
        audiobookfirstAuthor.type = .string
        audiobook.properties.append(audiobookfirstAuthor)
        let audiobookauthorDOB = NSAttributeDescription()
        audiobookauthorDOB.name = "authorDOB"
        audiobookauthorDOB.type = .string
        audiobook.properties.append(audiobookauthorDOB)
        let audiobookauthorDOD = NSAttributeDescription()
        audiobookauthorDOD.name = "authorDOD"
        audiobookauthorDOD.type = .string
        audiobook.properties.append(audiobookauthorDOD)
        let audiobooktotaltime = NSAttributeDescription()
        audiobooktotaltime.name = "totalTimeSecs"
        audiobooktotaltime.type = .integer64
        audiobook.properties.append(audiobooktotaltime)

        //        Librivox audiobook to book Relationship
        let audiobooksBookRelationship = NSRelationshipDescription()
        let booksAudiobookRelationship = NSRelationshipDescription()
        audiobooksBookRelationship.name = "book"
        audiobooksBookRelationship.destinationEntity = book
        audiobooksBookRelationship.minCount = 0
        audiobooksBookRelationship.maxCount = 1
        audiobooksBookRelationship.inverseRelationship = booksAudiobookRelationship
        
        booksAudiobookRelationship.name = "audiobook"
        booksAudiobookRelationship.destinationEntity = audiobook
        booksAudiobookRelationship.minCount = 0
        booksAudiobookRelationship.maxCount = 1
        booksAudiobookRelationship.inverseRelationship = audiobooksBookRelationship
        //        Append
        audiobook.properties.append(audiobooksBookRelationship)
        book.properties.append(booksAudiobookRelationship)
        
//        Author Attirbutes
        let authorNameAttribute = NSAttributeDescription()
        authorNameAttribute.name = "name"
        authorNameAttribute.type = .string
        author.properties.append(authorNameAttribute)
        let authorUriAttribute = NSAttributeDescription()
        authorUriAttribute.name = "uri"
        authorUriAttribute.type = .string
        author.properties.append(authorUriAttribute)
        let authorBookCountDerivedAttribute = NSDerivedAttributeDescription()
        authorBookCountDerivedAttribute.name = "booksCount"
        authorBookCountDerivedAttribute.type = .integer64
        authorBookCountDerivedAttribute.derivationExpression = NSExpression(format: "books.@count")
        author.properties.append(authorBookCountDerivedAttribute)
        let authorUpdateAttribute = NSAttributeDescription()
        authorUpdateAttribute.name = "updatedAt"
        authorUpdateAttribute.type = .date
        author.properties.append(authorUpdateAttribute)
        let authorDidAddAttribute = NSAttributeDescription()
        authorDidAddAttribute.name = "didAdd"
        authorDidAddAttribute.type = .boolean
        author.properties.append(authorDidAddAttribute)
        
//        Subject
        let subjectNameAttribute = NSAttributeDescription()
        subjectNameAttribute.name = "name"
        subjectNameAttribute.type = .string
        subject.properties.append(subjectNameAttribute)
        let subjectSymbolNameAttribute = NSAttributeDescription()
        subjectSymbolNameAttribute.name = "symbolName"
        subjectSymbolNameAttribute.type = .string
        subject.properties.append(subjectSymbolNameAttribute)
        let subjectBookCountDerivedAttribute = NSDerivedAttributeDescription()
        subjectBookCountDerivedAttribute.name = "booksCount"
        subjectBookCountDerivedAttribute.type = .integer64
        subjectBookCountDerivedAttribute.derivationExpression = NSExpression(format: "books.@count")
        subject.properties.append(subjectBookCountDerivedAttribute)
        let subjectUpdateAttribute = NSAttributeDescription()
        subjectUpdateAttribute.name = "updatedAt"
        subjectUpdateAttribute.type = .date
        subject.properties.append(subjectUpdateAttribute)
        let isSESubjectAttribute = NSAttributeDescription()
        isSESubjectAttribute.name = "isSESubject"
        isSESubjectAttribute.type = .boolean
        subject.properties.append(isSESubjectAttribute)
        let subjectDidAddAttribute = NSAttributeDescription()
        subjectDidAddAttribute.name = "didAdd"
        subjectDidAddAttribute.type = .boolean
        subject.properties.append(subjectDidAddAttribute)
        
//        Category
        let categoryNameAttribute = NSAttributeDescription()
        categoryNameAttribute.name = "name"
        categoryNameAttribute.type = .string
        category.properties.append(categoryNameAttribute)
        let categoryBookCountDerivedAttribute = NSDerivedAttributeDescription()
        categoryBookCountDerivedAttribute.name = "booksCount"
        categoryBookCountDerivedAttribute.type = .integer64
        categoryBookCountDerivedAttribute.derivationExpression = NSExpression(format: "books.@count")
        category.properties.append(categoryBookCountDerivedAttribute)
        let categoryUpdateAttribute = NSAttributeDescription()
        categoryUpdateAttribute.name = "updatedAt"
        categoryUpdateAttribute.type = .date
        category.properties.append(categoryUpdateAttribute)
        let categoryIsSESubjectAttribute = NSAttributeDescription()
        categoryIsSESubjectAttribute.name = "isSESubject"
        categoryIsSESubjectAttribute.type = .boolean
        category.properties.append(categoryIsSESubjectAttribute)
        let categoryDidAddAttribute = NSAttributeDescription()
        categoryDidAddAttribute.name = "didAdd"
        categoryDidAddAttribute.type = .boolean
        category.properties.append(categoryDidAddAttribute)
        
//                Collection
        let collectionNameAttribute = NSAttributeDescription()
        collectionNameAttribute.name = "name"
        collectionNameAttribute.isOptional = false
        collectionNameAttribute.type = .string
        collection.properties.append(collectionNameAttribute)
        let collectionTypeAttribute = NSAttributeDescription()
        collectionTypeAttribute.name = "type"
        collectionTypeAttribute.type = .string
        collection.properties.append(collectionTypeAttribute)
        let collectionBookCountDerivedAttribute = NSDerivedAttributeDescription()
        collectionBookCountDerivedAttribute.name = "itemCount"
        collectionBookCountDerivedAttribute.type = .integer64
        collectionBookCountDerivedAttribute.derivationExpression = NSExpression(format: "collectionItems.@count")
        collection.properties.append(collectionBookCountDerivedAttribute)
        let collectionUpdateAttribute = NSAttributeDescription()
        collectionUpdateAttribute.name = "updatedAt"
        collectionUpdateAttribute.type = .date
        collection.properties.append(collectionUpdateAttribute)
        let collectionDidAddAttribute = NSAttributeDescription()
        collectionDidAddAttribute.name = "didAdd"
        collectionDidAddAttribute.type = .boolean
        collection.properties.append(collectionDidAddAttribute)
        
        //                Collection Item
        let collectionItemNameAttribute = NSAttributeDescription()
        collectionItemNameAttribute.name = "name"
        collectionItemNameAttribute.type = .string
        //collectionItemNameDerivedAttribute.derivationExpression = NSExpression(format: "collection.name")
        collectionItem.properties.append(collectionItemNameAttribute)
        let collectionItemPositionAttribute = NSAttributeDescription()
        collectionItemPositionAttribute.name = "position"
        collectionItemPositionAttribute.type = .integer32
        collectionItem.properties.append(collectionItemPositionAttribute)
        let collectionItemRankAttribute = NSAttributeDescription()
        collectionItemRankAttribute.name = "rank"
        collectionItemRankAttribute.type = .integer32
        collectionItem.properties.append(collectionItemRankAttribute)
        let collectionItemUpdateAttribute = NSAttributeDescription()
        collectionItemUpdateAttribute.name = "updatedAt"
        collectionItemUpdateAttribute.type = .date
        collectionItem.properties.append(collectionItemUpdateAttribute)
        let collectionItemBookIdAttribute = NSAttributeDescription()
        collectionItemBookIdAttribute.name = "bookId"
        collectionItemBookIdAttribute.type = .string
        collectionItem.properties.append(collectionItemBookIdAttribute)
//        let collectionItemBookIdDerivedAttribute = NSDerivedAttributeDescription()
//        collectionItemBookIdDerivedAttribute.name = "bookId"
//        collectionItemBookIdDerivedAttribute.type = .string
//        collectionItemBookIdDerivedAttribute.derivationExpression = NSExpression(format: "book.url")
//        collectionItem.properties.append(collectionItemBookIdDerivedAttribute)
        
//        Uniqueness
        book.uniquenessConstraints = [[urlAttribute]]
        author.uniquenessConstraints = [[authorNameAttribute]]
        subject.uniquenessConstraints = [[subjectNameAttribute]]
        category.uniquenessConstraints = [[categoryNameAttribute]]
        collection.uniquenessConstraints = [[collectionNameAttribute]]
//        collectionItem.uniquenessConstraints = [[collectionItemBookIdAttribute]]
//        collectionItem.uniquenessConstraints = [[collectionItemNameAttribute, collectionItemRankAttribute]]
        
//        Relationships
        //        Author
        let authorsBookRelationship = NSRelationshipDescription()
        let booksAuthorRelationship = NSRelationshipDescription()
        authorsBookRelationship.name = "books"
        authorsBookRelationship.destinationEntity = book
        authorsBookRelationship.maxCount = 0
        authorsBookRelationship.minCount = 0
        authorsBookRelationship.inverseRelationship = booksAuthorRelationship
        //        inverse subject
        booksAuthorRelationship.destinationEntity = author
        booksAuthorRelationship.name = "authors"
        booksAuthorRelationship.minCount = 0
        booksAuthorRelationship.maxCount = 0
        booksAuthorRelationship.inverseRelationship = authorsBookRelationship
        //        append
        author.properties.append(authorsBookRelationship)
        book.properties.append(booksAuthorRelationship)
        
//        Subject
        let subjectsBooksRelationship = NSRelationshipDescription()
        let booksSubjectRelationship = NSRelationshipDescription()
        subjectsBooksRelationship.name = "books"
        subjectsBooksRelationship.destinationEntity = book
        subjectsBooksRelationship.maxCount = 0
        subjectsBooksRelationship.minCount = 0
        subjectsBooksRelationship.inverseRelationship = booksSubjectRelationship
//        inverse subject
        booksSubjectRelationship.destinationEntity = subject
        booksSubjectRelationship.name = "subjects"
        booksSubjectRelationship.minCount = 0
        booksSubjectRelationship.maxCount = 0
        booksSubjectRelationship.inverseRelationship = subjectsBooksRelationship
//        append
        subject.properties.append(subjectsBooksRelationship)
        book.properties.append(booksSubjectRelationship)
        
//        Category Relationship
        let categoryBooksRelationship = NSRelationshipDescription()
        let booksCategoryRelationship = NSRelationshipDescription()
        categoryBooksRelationship.name = "books"
        categoryBooksRelationship.destinationEntity = book
        categoryBooksRelationship.minCount = 0
        categoryBooksRelationship.maxCount = 0
        categoryBooksRelationship.inverseRelationship = booksCategoryRelationship
        
        booksCategoryRelationship.name = "categories"
        booksCategoryRelationship.destinationEntity = category
        booksCategoryRelationship.minCount = 0
        booksCategoryRelationship.maxCount = 0
        booksCategoryRelationship.inverseRelationship = categoryBooksRelationship
//        Append
        category.properties.append(categoryBooksRelationship)
        book.properties.append(booksCategoryRelationship)
        
        //        Collection Relationship
        let collectionItemsBookRelationship = NSRelationshipDescription()
        let booksCollectionItemsRelationship = NSRelationshipDescription()
        collectionItemsBookRelationship.name = "book"
        collectionItemsBookRelationship.destinationEntity = book
        collectionItemsBookRelationship.minCount = 0
        collectionItemsBookRelationship.maxCount = 1
        collectionItemsBookRelationship.inverseRelationship = booksCollectionItemsRelationship
        
        booksCollectionItemsRelationship.name = "collectionItems"
        booksCollectionItemsRelationship.destinationEntity = collectionItem
        booksCollectionItemsRelationship.minCount = 0
        booksCollectionItemsRelationship.maxCount = 0
        booksCollectionItemsRelationship.inverseRelationship = collectionItemsBookRelationship
        //        Append
        collectionItem.properties.append(collectionItemsBookRelationship)
        book.properties.append(booksCollectionItemsRelationship)
        
        //        Collection Relationship
        let collectionsCollectionItemsRelationship = NSRelationshipDescription()
        let collectionItemsCollectionRelationship = NSRelationshipDescription()
        collectionsCollectionItemsRelationship.name = "collectionItems"
        collectionsCollectionItemsRelationship.destinationEntity = collectionItem
        collectionsCollectionItemsRelationship.minCount = 0
        collectionsCollectionItemsRelationship.maxCount = 0
        collectionsCollectionItemsRelationship.inverseRelationship = collectionItemsCollectionRelationship
        
        collectionItemsCollectionRelationship.name = "collection"
        collectionItemsCollectionRelationship.destinationEntity = collection
        collectionItemsCollectionRelationship.minCount = 0
        collectionItemsCollectionRelationship.maxCount = 1
        collectionItemsCollectionRelationship.inverseRelationship = collectionsCollectionItemsRelationship
        //        Append
        collection.properties.append(collectionsCollectionItemsRelationship)
        collectionItem.properties.append(collectionItemsCollectionRelationship)
        
//        Create Data Model
        let model = NSManagedObjectModel()
        model.entities = [book, author, subject, category, collection, collectionItem, audiobook]
        
        /// - Tag: persistentContainer
        let container = NSPersistentContainer(name: "StandardEbooks", managedObjectModel: model)
        /// - Tag: persistentContainer
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve a persistent store description.")
        }
        
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // This sample refreshes UI by consuming store changes via persistent history tracking.
        /// - Tag: viewContextMergeParentChanges
        container.viewContext.automaticallyMergesChangesFromParent = true // maybe false?
//        container.viewContext.name = "viewContext"
        /// - Tag: viewContextMergePolicy
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        container.viewContext.undoManager = nil
//        container.viewContext.shouldDeleteInaccessibleFaults = true
        self.container = container
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
                let nsError = error as NSError
                fatalError("Unresolved Error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func createRelationship(for audioBook: LibriVox.Books, and entryId: String) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "createCollectionItemRelationship"
        
        try await taskContext.perform {
            let request = NSFetchRequest<Book>(entityName: "Book")
            request.predicate = NSPredicate(format: "id = %@", entryId)
            do {
                let books = try taskContext.fetch(request)
                if let book = books.first {
                    let librivoxBook = LibrivoxBook(context: taskContext)
                    librivoxBook.title = audioBook.title
                    librivoxBook.language = audioBook.language
                    librivoxBook.url = audioBook.appUrl //?? audioBook.urlLibrivox ?? "https://librivox.org/"
                    librivoxBook.totalTimeSecs = audioBook.totaltimesecs as NSNumber
                    librivoxBook.firstAuthor = audioBook.authors.first?.fullName
                    librivoxBook.authorDOB = audioBook.authors.first?.dob
                    librivoxBook.authorDOD = audioBook.authors.first?.dod
                    librivoxBook.book = book
                }
            }
            
            try taskContext.save()
        }
    }
    /// Creates and configures a private queue context.
    func newTaskContext() -> NSManagedObjectContext {
        // Create a private queue context.
        /// - Tag: newBackgroundContext
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        // Set unused undoManager to nil for macOS (it is nil by default on iOS)
        // to reduce resource requirements.
        taskContext.undoManager = nil
        return taskContext
    }
//    private var githubSearchResults: [Response] = []
    struct GithubEndpoints {
        let searchForCollections = "https://api.github.com/search/code?q=belongs-to-collection+in:file+filename:content+org:standardebooks"
        let rawContent = "https://raw.githubusercontent.com"
        func searchFor(authorUnderbarTitle: String) -> String {
            return "https://api.github.com/search/code?q=\(authorUnderbarTitle)+in:file+filename:content+org:standardebooks"
        }
    }
    func fetchAllGithubCollections() async {
        //        TODO: better progress bar, use totalCount
        try? await fetchGithubSearchResults()
        save()
    }
    func createEntryIdFromGithub(opfUrl: String) -> String? {
        let standardURL = URL(string: OpdsEndpoints().index)!
        let githubURL = URL(string: opfUrl)!
        var components = URLComponents()
        components.scheme = "https"
        components.host = standardURL.host
        if let name = githubURL.pathComponents.first(where: { str in
            str.contains("_")
        }){
            let underscores = name.compactMap { char in
                char == Character("_")
            }.filter { k in
                k == true
            }
            var newName: String = ""
            if underscores.count > 1 {
                // If there are more then one author/translator then the url with have two or more underbars
                var firstScore: String = ""
                if let range = name.range(of: "_") {
                    firstScore = name.replacingCharacters(in: range, with: "/")
                }
                if let range = firstScore.range(of: "_") {
                    newName = firstScore.replacingCharacters(in: range, with: "/")
                }
            } else {
                newName = name.replacingOccurrences(of: "_", with: "/")
            }
            components.path = "/ebooks/" + newName
            return "url:" + (components.string ?? "")
        }
        return nil
    }
    func createRawGithubURL(url: String) -> String {
        let standardURL = URL(string: GithubEndpoints().rawContent)!
        let githubURL = URL(string: url)!
        var components = URLComponents()
        components.scheme = "https"
        components.host = standardURL.host
        components.path = githubURL.path
        let componentsString = components.string ?? ""
        return componentsString.replacingOccurrences(of: "/blob", with: "")
    }
    
    func fetchGithubOPF(for searchTerm: String, on book: Book, hasCalledBefore: Bool = false) async throws {
        let endpoints = GithubEndpoints()
        let searchUrl = endpoints.searchFor(authorUnderbarTitle: searchTerm)
        print(searchUrl)
        guard let url = URL(string: searchUrl) else { return }
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            print("Failed to received valid response and/or data. fetchGithubOPF")
            throw SEError.missingData
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedResponse = try decoder.decode(Response.self, from: data)
            if decodedResponse.items.count == 0 {
//                if !hasCalledBefore {
//                    try await fetchGithubOPF(for: book.title_.lowerKebabCased(), on: book, hasCalledBefore: true)
//                }
            } else {
                if let item = decodedResponse.items.first {
                    let opfUrl = createRawGithubURL(url: item.htmlUrl)
                    if let entryId = createEntryIdFromGithub(opfUrl: opfUrl) {
                        try await fetchOpf(for: opfUrl, in: entryId)
                    }
                }
            }
        }
    }
    @available(iOS 15.0, *)
    func fetchGithubSearchResults(pageNum: Int = 1, resultLimit: Int = 100) async
    throws {
        var githubSearchResults: [Response] = []
        var itemArray: [Item] = []
        let urlParams = "&per_page=\(resultLimit)&page=\(pageNum)"
        let endpoints = GithubEndpoints() 
        guard let url = URL(string: endpoints.searchForCollections + urlParams) else { return }
        let session = URLSession.shared
        print(url)
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            print("Failed to received valid response and/or data. fetchGithubSearchResults")
            throw SEError.missingData
        }
        
        let task = Task { () -> Response? in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let decodedResponse = try? decoder.decode(Response.self, from: data) {
                if (decodedResponse.totalCount - (resultLimit * pageNum) >= 1) {
                    try await fetchGithubSearchResults(pageNum: pageNum + 1, resultLimit: resultLimit)
                }
                return decodedResponse
            }
            return nil
        }
        let result = await task.result
        do {
            if let res = try result.get() {
                githubSearchResults.append(res)
            }
        } catch {
            print("github fetch error")
        }
        itemArray = githubSearchResults.flatMap { res in
            res.items
        }
        print("Received \(itemArray.count) records")
        
        // Import the Github OPF data into Core Data.
        print("Start importing books to the store...")
        try await importCollectionItems(for: itemArray)
        print("Finished creating book relationships data.")
//        Finished loading collections More Books by this author can now load
        // isLoading = false
    }
    func importCollectionItems(for searchResults: [Item]) async throws {
        for item in searchResults {
            let opfUrl = createRawGithubURL(url: item.htmlUrl)
            if let entryId = createEntryIdFromGithub(opfUrl: opfUrl) {
                try await fetchOpf(for: opfUrl, in: entryId)
            }
        }
    }
    
    func fetchOpf(for opfUrl: String, in entryId: String) async throws {
//        let taskContext = newTaskContext()
//        // Add name and author to identify source of persistent history changes.
//        taskContext.name = "importContext"
//        taskContext.transactionAuthor = "createRelationship"
        guard let url = URL(string: opfUrl) else { return }
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            print("Failed to received valid response and/or data. fetchOpf")
            throw SEError.missingData
        }
        let opfDecoder = OPFParser(xmlData: data, bookId: entryId)
        let collections = opfDecoder.collections
        let metaData = opfDecoder.itemMetadata
//        print(metaData)
//        print(collections)
        try await importItemMetadata(from: metaData)
        if collections.count > 0 {
            try await importCollectionItems(from: collections)
            try await importBookCollections(from: collections)
            try await createRelationship(for: entryId, and: collections)
            try await createRelationship(for: collections)
        }
    }
    
    func createRelationship(for entryId: String, and collectionItems: [SECollection]) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "createCollectionItemRelationship"
        
        try await taskContext.perform {
            let request = NSFetchRequest<Book>(entityName: "Book")
            request.predicate = NSPredicate(format: "id = %@", entryId)
            do {
                let books = try taskContext.fetch(request)
                if let book = books.first {
                    for item in collectionItems {
                        let request = NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
                        request.predicate = NSPredicate(format: "bookId = %@", item.bookId ?? "")
                        let collectionIs = try taskContext.fetch(request)
                        if let item = collectionIs.first {
                            book.addToCollectionItems(item)
                        }
                    }
                }
            }
            
            try taskContext.save()
        }
    }
    
    func createRelationship(for collectionItems: [SECollection]) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "createBookCollectionRelationship"
        
        try await taskContext.perform {
            for item in collectionItems {
                let request = NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
                request.predicate = NSPredicate(format: "bookId = %@", item.bookId ?? "")
                let collectionIs = try taskContext.fetch(request)
                if let item = collectionIs.first {
                    let request = NSFetchRequest<BookCollection>(entityName: "BookCollection")
                    request.predicate = NSPredicate(format: "name = %@", item.name_)
                    let bookCollections = try taskContext.fetch(request)
                    if let bookCollection = bookCollections.first {
                        print("create book collection relationship")
                        bookCollection.addToCollectionItems(item)
                    }
                }
            }
            try taskContext.save()
        }
    }
    
    /// Uses `NSBatchInsertRequest` (BIR) to import a XML dictionary into the Core Data store on a private queue.
    private func importItemMetadata(from metadata: OPFMetadata) async throws {
        guard !metadata.isEmpty else { return }
        
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importItemMetadata"
        /// - Tag: performAndWait
        try await taskContext.perform {
            let request = NSFetchRequest<Book>(entityName: "Book")
            request.predicate = NSPredicate(format: "id = %@", metadata.id ?? "")
            do {
                let books = try taskContext.fetch(request)
                if let book = books.first {
                    book.wordCount = metadata.wordCount as NSNumber?
                    book.wikipedia = metadata.wikipedia
                    book.readingEase = metadata.readingEase as NSNumber?
                    book.didAddGithub = true
                    book.objectWillChange.send()
                    print("updated book \(book)")
                }
            }
            try taskContext.save()
        }
        
        print("Successfully inserted data.")
    }
    
    /// Uses `NSBatchInsertRequest` (BIR) to import a XML dictionary into the Core Data store on a private queue.
    private func importBookCollections(from collectionItems: [SECollection]) async throws {
        guard !collectionItems.isEmpty else { return }
        
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importBookCollections"
        
        /// - Tag: performAndWait
        try await taskContext.perform {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequest = self.newBatchInsertRequest(withBC: collectionItems)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Books")
            throw SEError.batchInsertError
        }
        
        print("Successfully inserted data.")
    }
    
    private func newBatchInsertRequest(withBC bookCollection: [SECollection]) -> NSBatchInsertRequest {
        var index = 0
        let total = bookCollection.count
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: BookCollection.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: bookCollection[index].collectionDictionaryValue)
//            print("book Collection \(dictionary)")
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    /// Uses `NSBatchInsertRequest` (BIR) to import a XML dictionary into the Core Data store on a private queue.
    private func importCollectionItems(from collectionItems: [SECollection]) async throws {
        guard !collectionItems.isEmpty else { return }
        
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importCollectionItems"
        
        /// - Tag: performAndWait
        try await taskContext.perform {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequest = self.newBatchInsertRequest(with: collectionItems)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Books")
            throw SEError.batchInsertError
        }
        
        print("Successfully inserted data.")
    }
    
    private func newBatchInsertRequest(with collection: [SECollection]) -> NSBatchInsertRequest {
        var index = 0
        let total = collection.count
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: CollectionItem.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: collection[index].itemDictionaryValue)
//            print("Collection item \(dictionary)")
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    func fetchBooks() async throws {
        isLoading = true
        // Batch Import all books, authors, and subjects
        try await importSubjects(for: allSubjects)
        try await fetchAllBooks()
        // Create relationships between objects
        
        for subject in allSubjects {
            try await fetchBooksForSubject(name: subject.name, isCustom: subject.isCustom)
        }
        isLoading = false
    }
    
    func fetchBooksForSubject(name subject: String, isCustom: Bool = false) async throws {
        let endpoints = OpdsEndpoints()
        guard let url = URL(string: isCustom
                            ? endpoints.search + subject.lowercased()
                            : endpoints.subjects + subject.lowercased()
        ) else { return }
        
        var request = URLRequest(url: url)
        if (!isCustom) {
            request.addValue("VockV3fu1c7vBvaG7A4oMALa9WIrPekx8jeH5HeBzuxir2X6NcAE5w==", forHTTPHeaderField: "x-functions-key")
            request.addValue("Basic YmlvdGFfdGlwc3Rlcl8wY0BpY2xvdWQuY29tOg==", forHTTPHeaderField: "Authorization")
            request.addValue("sessionid=a701da9f-cddc-4c5b-8587-1f379fca968e", forHTTPHeaderField: "Cookie")
        }
        print(url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(for: request),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            print("Failed to received valid response and/or data. fetchBooksForSubject")
            throw SEError.missingData
        }
        
        do {
            print("fetching \(subject)")
            //let contentDecoder = ContentParser(xmlData: data)
            // Decode the SE subject XML into a data model.
            let bookFeedXML = try XMLDecoder().decode(BookFeed.self, from: data)
            let feedEntriesList = bookFeedXML.entries
            print("Received \(feedEntriesList.count) records")
            
            // Import the XML into Core Data.
            print("Start importing books to the store...")
            try await createRelationship(for: subject, and: feedEntriesList)
            print("Finished creating book relationships data.")
        } catch {
            throw SEError.wrongDataFormat(error: error)
        }
        // isLoading = false
    }
    func createRelationship(for name: String, and entries: [FeedEntry]) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "createBookSubjectRelationship"
        
        try await taskContext.perform {
            let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
            request.predicate = NSPredicate(format: "name = %@", name)
            do {
                let subjects = try taskContext.fetch(request)
                if let subject = subjects.first {
                    for entry in entries {
                        let request = NSFetchRequest<Book>(entityName: "Book")
                        request.predicate = NSPredicate(format: "id = %@", entry.id)
                        let books = try taskContext.fetch(request)
                        if let book = books.first {
                            print("\(subject.name_) adds \(book.title_)")
                            subject.addToBooks(book)
                            let entryCategories = entry.categories
                            try entryCategories?.forEach({ categroy in
                                let request = NSFetchRequest<BookCategory>(entityName: "BookCategory")
                                request.predicate = NSPredicate(format: "name = %@", categroy.term)
                                let categories = try taskContext.fetch(request)
                                if let cat = categories.first {
                                    cat.addToBooks(book)
                                }
                            })
                            let entryAuthors = entry.authors
                            try entryAuthors.forEach({ person in
                                let request = NSFetchRequest<BookAuthor>(entityName: "BookAuthor")
                                request.predicate = NSPredicate(format: "name = %@", person.name)
                                let authors = try taskContext.fetch(request)
                                if let author = authors.first {
                                    author.addToBooks(book)
                                }
                            })
                        }
                    }
                }
                try taskContext.save()
            } catch let error {
                print("Error fetching subject \(error)")
                print("Failed to execute create relationship. Subjects")
                throw SEError.missingData
            }
        }
    }
    
    func getLoginString() -> String {
        let username = "biota_tipster_0c@icloud.com"
//        let password = ""
        let loginString = String(format: "%@", username)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
    
    /// Fetches all the books from the SE subjects feed and imports it into Core Data.
    func fetchAllBooks() async throws {
        
        let endpoints = OpdsEndpoints()
        guard let url = URL(string: endpoints.all) else { return }
        
        var request = URLRequest(url: url)
//        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("VockV3fu1c7vBvaG7A4oMALa9WIrPekx8jeH5HeBzuxir2X6NcAE5w==", forHTTPHeaderField: "x-functions-key")
        request.addValue("Basic YmlvdGFfdGlwc3Rlcl8wY0BpY2xvdWQuY29tOg==", forHTTPHeaderField: "Authorization")
        request.addValue("sessionid=a701da9f-cddc-4c5b-8587-1f379fca968e", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "GET"
        let session = URLSession.shared
//        print(request.allHTTPHeaderFields)
        guard let (data, response) = try? await session.data(for: request),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            print("Failed to received valid response and/or data. fetchAllBooks")
            throw SEError.missingData
        }
        
        do {
            // Decode the SE XML into a data model.
            let bookFeedXML = try XMLDecoder().decode(BookFeed.self, from: data)
            let feedEntriesList = bookFeedXML.entries
            print("Received \(feedEntriesList.count) records")
            
            // Import the XML into Core Data.
            print("Start importing books to the store...")
            try await importBooks(from: feedEntriesList)
            try await importAuthors(from: feedEntriesList.flatMap({ entry in
                entry.authors
            }))
            try await importCategories(from: feedEntriesList.flatMap({ entry in
                entry.categories ?? []
            }))
            print("Finished importing data.")
        } catch {
            throw SEError.wrongDataFormat(error: error)
        }
    }
    
    private func importSubjects(from category: [Category]) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importSubjects"
        
        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(withSE: category)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Subjects")
            throw SEError.batchInsertError
        }
    }
    
    
    private func importCategories(from category: [Category]) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importCategories"
        
        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(with: category)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Subjects")
            throw SEError.batchInsertError
        }
    }
    
    private func importAuthors(from authors: [Author]) async throws {
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importAuthors"
        
        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(with: authors)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Subjects")
            throw SEError.batchInsertError
        }
    }
    
    private func importSubjects(for subjects: [AllSubjects]) async throws {
//        guard !subject.isCustom else { return }
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importSubjects"
        
        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(with: subjects)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Subjects")
            throw SEError.batchInsertError
        }
    }
    
    /// Uses `NSBatchInsertRequest` (BIR) to import a XML dictionary into the Core Data store on a private queue.
    private func importBooks(from feedEntryList: [FeedEntry]) async throws {
        guard !feedEntryList.isEmpty else { return }
        
        let taskContext = newTaskContext()
        // Add name and author to identify source of persistent history changes.
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importBooks"
        
        /// - Tag: performAndWait
        try await taskContext.perform {
            // Execute the batch insert.
            /// - Tag: batchInsertRequest
            let batchInsertRequest = self.newBatchInsertRequest(with: feedEntryList)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            print("Failed to execute batch insert request. Books")
            throw SEError.batchInsertError
        }
        
        print("Successfully inserted data.")
    }
    private func newBatchInsertRequest(withSE category: [Category]) -> NSBatchInsertRequest {
        var index = 0
        let total = category.count
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: BookSubject.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            if category[index].isSESubject {
                dictionary.addEntries(from: category[index].dictionaryValue)
            }
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    private func newBatchInsertRequest(with category: [Category]) -> NSBatchInsertRequest {
        var index = 0
        let total = category.count
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: BookCategory.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: category[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    private func newBatchInsertRequest(with authors: [Author]) -> NSBatchInsertRequest {
        var index = 0
        let total = authors.count
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: BookAuthor.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: authors[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    private func newBatchInsertRequest(with subjects: [AllSubjects]) -> NSBatchInsertRequest {
        var index = 0
        let total = subjects.count
        //        print("creating new BIR for")
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: BookSubject.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: subjects[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    private func newBatchInsertRequest(with feedEntryList: [FeedEntry]) -> NSBatchInsertRequest {
        var index = 0
        let total = feedEntryList.count
//        print("creating new BIR for")
        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: Book.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: feedEntryList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    
    
//    func fetchPersistentHistory() async {
//        do {
//            try await fetchPersistentHistoryTransactionsAndChanges()
//        } catch {
//            print("\(error.localizedDescription)")
//        }
//    }
//    
//    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
//        let taskContext = newTaskContext()
//        taskContext.name = "persistentHistoryContext"
//        print("Start fetching persistent history changes from the store...")
//        
//        try await taskContext.perform {
//            // Execute the persistent history change since the last transaction.
//            /// - Tag: fetchHistory
//            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
//            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
//            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
//               !history.isEmpty {
//                self.mergePersistentHistoryChanges(from: history)
//                return
//            }
//            
//            print("No persistent history transactions found.")
//            throw SEError.persistentHistoryChangeError
//        }
//        
//        print("Finished merging history changes.")
//    }
//    
//    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
//        print("Received \(history.count) persistent history transactions.")
//        // Update view context with objectIDs from history change request.
//        /// - Tag: mergeChanges
//        let viewContext = container.viewContext
//        viewContext.perform {
//            for transaction in history {
//                viewContext.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
//                self.lastToken = transaction.token
//            }
//        }
//    }
}


/// An extension to format strings in *snake case*.
extension String {
    
    /// A collection of all the words in the string by separating out any punctuation and spaces.
    var words: [String] {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
    }
    
    /// Returns a lowercased copy of the string with punctuation removed and spaces replaced
    /// by a single underscore, e.g., "the_quick_brown_fox_jumps_over_the_lazy_dog".
    ///
    /// *Lower snake case* (or, illustratively, *snake_case*) is also known as *pothole case*.
    func lowerSnakeCased() -> String {
        return self.words.map({ $0.lowercased() }).joined(separator: "_")
    }
    
    /// Returns an uppercased copy of the string with punctuation removed and spaces replaced
    /// by a single underscore, e.g., "THE_QUICK_BROWN_FOX_JUMPS_OVER_THE_LAZY_DOG".
    ///
    /// *Upper snake case* (or, illustratively, *SNAKE_CASE*) is also known as
    /// *screaming snake case*.
    func upperSnakeCased() -> String {
        return self.words.map({ $0.uppercased() }).joined(separator: "_")
    }
    
    /// Returns a copy of the string with punctuation removed and spaces replaced by a single
    /// underscore, e.g., "The_quick_brown_fox_jumps_over_the_lazy_dog". Upper and lower
    /// casing is maintained from the original string.
    func mixedSnakeCased() -> String {
        return self.words.joined(separator: "_")
    }
    
    func lowerKebabCased() -> String {
        return self.words.map({ $0.lowercased() }).joined(separator: "-")
    }
    
    func upperKebabCased() -> String {
        return self.words.map({ $0.uppercased() }).joined(separator: "-")
    }
    
    func mixedKebabCased() -> String {
        return self.words.joined(separator: "-")
    }
    
    func lowerPlusCased() -> String {
        return self.words.map({ $0.lowercased() }).joined(separator: "+")
    }
    
    func upperPlusCased() -> String {
        return self.words.map({ $0.uppercased() }).joined(separator: "+")
    }
    
    func mixedPlusCased() -> String {
        return self.words.joined(separator: "+")
    }
}

struct AllSubjects {
    var name: String
    var symbolName: String
    var isCustom = false
    
    // The keys must have the same name as the attributes of the Book entity.
    var dictionaryValue: [String: Any] {
        [
            "name": name,
            "symbolName": symbolName,
        ]
    }
}
