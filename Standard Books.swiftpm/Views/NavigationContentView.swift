import SwiftUI

struct NavigationContentView: View {
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "itemCount", ascending: false),
    ])
    private var featuredCollections: FetchedResults<BookCollection>
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "booksCount", ascending: false),
    ])
    private var featuredAuthors: FetchedResults<BookAuthor>
    var body: some View {
        NavigationView {
//            if viewModel.searchText == "" {
            List {
//                NavigationLink(destination: HomeView()) {
//                    Label("Home", systemImage: "house")
//                }
                NavigationLink(destination: NewestReleasesView()) { 
                    Label("Newest Releases", systemImage: "newspaper.fill")
                }
                NavigationLink { 
                    List {
                        FeaturedSections(featuredCollections: Array(featuredCollections.prefix(10)), featuredAuthors: Array(featuredAuthors.prefix(10)))
                    }
                    .listStyle(.plain)
                } label: { 
                    Label("Featured", systemImage: "star")
                }
                BrowseList()
            }
            .navigationTitle("Standard eBooks Browser")
            NewestReleasesView()
//            } else {
//                List {
//                    if isLoadingResults {
//                        ProgressView()
//                    } else {
//                        if opdsResults.count > 0 {
//                            BookList(books: opdsResults)
//                        }
//                        if suggestedResults.count > 0 && opdsResults.count == 0 {
//                            Section("Suggested") {
//                                BookList(books: opdsResults)
//                            }
//                        }
//                    }
//                }
//            }
//        } // NavigationView
//        .searchable(text: $viewModel.searchText)
////        .autocapitalization(.none)
//        .onSubmit(of: .search) { // search results
//            isLoadingResults = true
//            Task {
//                try await viewModel.fetchOpdsSearchResults(searchTerm: viewModel.searchText)
//                isLoadingResults = false
        }
    }
//        .onChange(of: viewModel.searchText) { _ in viewModel.submitCurrentSearchQuery() } // search suggestions
}
//    
//    var opdsResults: [Book] {
//        if viewModel.opdsSearchResults.isEmpty {
//            return []
//        } else {
//            return viewModel.opdsSearchResults
//        }
//    }
//    
//    var suggestedResults: [Book] {
//        if viewModel.searchText.isEmpty {
//            return []
//        } else {
//            return viewModel.searchResults
//        }
//    }
//}
//
//struct AllSubjectsRow: View {
//    var subjectName: String
//    var symbolName: String
//    var body: some View {
//        Label(subjectName, systemImage: symbolName)
//    }
//}
