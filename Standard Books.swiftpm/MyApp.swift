import SwiftUI

@main
struct MyApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
// init() {
// let booksProvider: PersistenceController = .shared 
// self.persistenceController = booksProvider
// Task {
// fetch local data if initial install
//try await booksProvider.fetchBooks()
    // fetch all github results???
//try await booksProvider.fetchGithubSearchResults()
//}
//}
