import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
//    var showForYou: Bool {
//        viewModel.forYouAuthor.count + viewModel.forYouCategory.count > 0
//    }
//    var moreAuthorText: String {
//        "More by \(viewModel.forYouAuthor.first?.firstAuthor ?? "this author")"
//    }
//    var moreCategoryText: String {
//        "\(viewModel.forYouCategory.first?.name_ ?? "Category")"
//    }
    var body: some View {
        Group {
        if viewModel.allAdded.count > 0 {
            List {
////            TODO: Shared with you books
                Section("Added books") {
                    HorizontalBookList(bookArray: viewModel.allAdded)
                }
//                if showForYou {
//                Section("For You") {
//                    if viewModel.forYouAuthor.count > 0 {
//                        VStack {
//                            NavigationLink(destination: List {
//                                BookList(books:viewModel.forYouAuthor)
//                                    .navigationTitle(moreAuthorText)
//                                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
//                            }){
//                                Text(moreAuthorText)
//                            }
//                            HorizontalBookList(bookArray: viewModel.forYouAuthor)
//                        }
//                    }
//                    if viewModel.forYouCategory.count > 0 {
//                        VStack {
//                            NavigationLink(destination: List {
//                                BookList(books: viewModel.forYouCategory.first?.books_ ?? [])
//                                    .navigationTitle(moreCategoryText)
//                                    .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
//                            }){
//                                Text(moreCategoryText)
//                            }
//                            HorizontalBookList(bookArray: viewModel.forYouCategory.first?.books_ ?? [])
//                        }
//                    }
//                }
//                }
            }
        } else {
            Text("Browse books from Standard eBooks.")
        }
        }
        .onAppear { viewModel.fetchAddedBooksFromCoreData() }
        .navigationTitle("Home")
    }
}

class HomeViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var allAdded: [Book] = []
    func fetchAddedBooksFromCoreData() {
        let request = NSFetchRequest<Book>(entityName: "Book")
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: true)]
        request.predicate = NSPredicate(format: "didAdd = true")
        do {
            allAdded = try self.viewContext.fetch(request)
        } catch let error {
            print("Error fetching all books \(error)")
        }
    }
}

struct HorizontalBookList: View {
    var bookArray: [Book]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 20) {
                ForEach(bookArray, id:\.url) { book in
                    NavigationLink(destination:  NewDetailPage(book: book)) { 
                        VStack(alignment:.leading) {
                            BookThumbnailImage(thumbnailUrl: book.thumbnailUrl_, hasAudiobook: book.hasAudiobook)
                            Text(book.title_)
                                .multilineTextAlignment(.leading)
                                .frame(
                                    minWidth: 100,
                                    maxWidth: 112.5
                                )
                                .lineLimit(1)
                                .font(.headline)
                            Text(book.firstAuthor)
                                .font(.subheadline)
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
            }
        }
    }
}
