import SwiftUI
import CoreData

struct CollectionList: View {
    @StateObject var viewModel = CollectionListViewModel()
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    var collectionName: String
    var body: some View {
            List {
                BookList(items: viewModel.collection)
            } //list
            .refreshable {
                await fetchCollections()
            }
            .onAppear { viewModel.fetchCollectionsFromCoreData(name: collectionName) }
            .navigationTitle(collectionName)
        }
    }


extension CollectionList {
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

class CollectionListViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var collection: [CollectionItem] = []
    
    func fetchCollectionsFromCoreData(name: String) {
        let request = NSFetchRequest<CollectionItem>(entityName: "CollectionItem")
        request.predicate = NSPredicate(format: "name = %@", name)
        request.sortDescriptors = [
            NSSortDescriptor(key: "position", ascending: true)
        ]
        request.fetchBatchSize = 10 // might not be needed
        request.relationshipKeyPathsForPrefetching = ["book"]  // relationships that we know will be traversed for this view
        //        request.propertiesToFetch // tailor requests for each view 
        do {
            collection = try self.viewContext.fetch(request)
//            for item in collectionItems {
//                if let book = item.book {
//                    self.collection.append(book)
//                }
//            }
        } catch let error {
            print("Error fetching all books \(error)")
        }
    }
}
