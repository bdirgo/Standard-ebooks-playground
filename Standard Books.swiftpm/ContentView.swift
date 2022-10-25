import SwiftUI
//import XMLCoder
import CoreData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @StateObject private var viewModel = ContentViewModel()
    var booksProvider: PersistenceController = .shared
    @State private var selection: Set<String> = []
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var body: some View {
        Group {
            if sizeClass == .compact {
                //phone
                TabContentView()
            } else {
                //ipad
                NavigationContentView()
            }
        }
        .environmentObject(viewModel)
//        NavigationView {
//            List {
//                ForEach(viewModel.subjects, id: \.name) { subject in
//                    NavigationLink(destination: SubjectList(books: subject.books_, name: subject.name_)) {
//                        Label(subject.name_, systemImage: subject.symbolName_)
//                    }
//                }
//            }
//            .listStyle(SidebarListStyle())
//            .navigationTitle(title)
//            .onAppear {
////                viewModel.fetchBookAuthorsFromCoreData()
//                viewModel.fetchBookSubjectsFromCoreData()
////                viewModel.fetchBooksFromCoreData()
//            }
//#if os(iOS)
//            .refreshable {
//                await fetchBooks()
//            }
//#else
//            .frame(minWidth: 320)
//#endif
//        }
        .alert(isPresented: $hasError, error: error) { }
    }
}

class ContentViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var books: [Book] = []
    @Published var subjects: [BookSubject] = []
    @Published var authors: [BookAuthor] = []
    func fetchBookSubjectsFromCoreData() {
        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            subjects = try self.viewContext.fetch(request)
        } catch let error {
            print("Error fetching all books \(error)")
        }
    }
}

extension Collection where Element: Equatable {
    /// Returns the second index where the specified value appears in the collection
    func secondIndex(of element: Element) -> Index? {
        guard let index = firstIndex(of: element) else { return nil }
        return self[self.index(after:index)...].firstIndex(of:element)
    }
}
