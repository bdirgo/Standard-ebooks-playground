import SwiftUI
import CoreData

struct CollectionsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = CollectionsViewModel() 
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    
    @FetchRequest private var collections: FetchedResults<BookCollection>
    init(predicate: NSPredicate, name: String = "Collections") {
        let request: NSFetchRequest<BookCollection> = BookCollection.fetchRequest(predicate)
        request.relationshipKeyPathsForPrefetching = ["collectionItems"] // relationships that we know will be traversed for this view  
        //        request.propertiesToFetch // tailor requests for each view 
        _collections = FetchRequest(fetchRequest: request)
        self.name = name
    }
    var name: String
    var body: some View {
        List {
            if collections.count > 0 {
                ForEach(collections, id:\.self) { collection in
                    NavigationLink(destination: CollectionList(collectionName: collection.name_)) {
                        Text("\(collection.name_)")
                    }
                }
            } else {
                Text("Pull to refresh...")
            }
        }
        .refreshable {
            await fetchCollections()
        }
        .navigationTitle(name)
    }
}

extension CollectionsView {
    private func fetchCollections() async {
        isLoading = true
        do {
            try await booksProvider.fetchGithubSearchResults()
        } catch {
            self.error = error as? SEError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}


class CollectionsViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var collections: [BookCollection] = []
    
    func fetchCollectionsFromCoreData() {
        let request = NSFetchRequest<BookCollection>(entityName: "BookCollection")
        request.sortDescriptors = [
            NSSortDescriptor(key: "itemCount", ascending: false)
        ]
        request.fetchBatchSize = 10 // might not be needed
        request.relationshipKeyPathsForPrefetching = ["collectionItems"]  // relationships that we know will be traversed for this view
        //        request.propertiesToFetch // tailor requests for each view 
        do {
            collections = try self.viewContext.fetch(request)
        } catch let error {
            print("Error fetching all books \(error)")
        }
    }
}
