import SwiftUI
import CoreData

struct SubjectList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var selectedSort = BookSort.initial
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    @FetchRequest private var books: FetchedResults<Book>
    var name: String
    init(name: String) {
        self.name = name
        _books = FetchRequest(sortDescriptors: BookSort.initial.descriptors, predicate: NSPredicate(format: "%K CONTAINS[c] %@", "subjects.name", name), animation: .default)
    }
    var body: some View {
        VStack {
            List {
                ForEach(books, id: \.self) { book in 
                    NavigationLink { 
                        NewDetailPage(book: book)
                    } label: {
                        BookListRow(book: book)
                    }
                }
            }
//            .toolbar(content: { 
//                // 1
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    // 2
//                    SortSelectionView(
//                        selectedSortItem: $selectedSort,
//                        sorts: BookSort.sorts)
//                    // 3
//                    .onChange(of: selectedSort) { _ in
//                        let request = books
//                        request.sortDescriptors = selectedSort.descriptors
//                    }
//                }
//                
//            })
            .toolbar { 
                SortSelectionView(selectedSortItem: $selectedSort, sorts: BookSort.sorts)
                    .onChange(of: selectedSort) { _ in
                        let request = books
                        request.sortDescriptors = selectedSort.descriptors
                    }
            }
            .navigationTitle(name)
            .refreshable {
                await fetchBooks(for: name)
            }
        }
    }
}

struct SubjectView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var viewModel = SubjectViewModel()
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    @FetchRequest private var subjects: FetchedResults<BookSubject>
    var title = "Subjects"
    init() {
        let request: NSFetchRequest<BookSubject> = BookSubject.fetchRequest()
        request.relationshipKeyPathsForPrefetching = ["books"]
        //request.sortDescriptors = [NSSortDescriptor(keyPath: \BookSubject.name, ascending: true)]
        _subjects = FetchRequest(fetchRequest: request)
    }
    var body: some View {
//        List {
            ForEach(subjects, id: \.name) { subject in
                NavigationLink(destination: SubjectList(name: subject.name_)) {
                    Label(subject.name_, systemImage: subject.symbolName_)
                }
            }
//        }
//        .listStyle(SidebarListStyle())
//        .navigationTitle(title)
//        .onAppear {
//            viewModel.fetchBookSubjectsFromCoreData()
//        }
#if os(iOS)
        .refreshable {
            await fetchBooks()
        }
#else
        .frame(minWidth: 320)
#endif
    }
}

extension SubjectView {
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

extension SubjectList {
    private func fetchBooks(for subjectName: String) async {
        isLoading = true
        do {
            let allSubject = booksProvider.allSubjects.filter { subject in
                subject.name == subjectName
            }
            print(allSubject)
            try await booksProvider.fetchBooksForSubject(name: name, isCustom: allSubject.first?.isCustom ?? false)
        } catch {
            self.error = error as? SEError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}


class SubjectViewModel: ObservableObject {
    var viewContext = PersistenceController.shared.container.viewContext
    @Published var subjects: [BookSubject] = []
    func fetchBookSubjectsFromCoreData() {
        let request = NSFetchRequest<BookSubject>(entityName: "BookSubject")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.relationshipKeyPathsForPrefetching = ["books"]
        do {
            subjects = try self.viewContext.fetch(request)
        } catch let error {
            print("Error fetching all books \(error)")
        }
    }
}


struct SubjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubjectView()
        }
    }
}
