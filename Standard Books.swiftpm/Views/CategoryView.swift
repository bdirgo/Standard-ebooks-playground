import SwiftUI
import CoreData

struct CategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @StateObject var viewModel = CategoryViewModel()
    @State private var isLoading = false
    @State private var error: SEError?
    @State private var hasError = false
    var booksProvider: PersistenceController = .shared
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(key: "booksCount", ascending: false),
    ], predicate: NSPredicate(format: "isSESubject = %@", "false"))
    private var categories: FetchedResults<BookCategory>
    var title = "Categories"
//    init() {
//        let predicate = NSPredicate(format: "isSESubject = %@", "false")
//        let request: NSFetchRequest<BookCategory> = BookCategory.fetchRequest(predicate)
        //request.sortDescriptors = [NSSortDescriptor(keyPath: \BookCategory.name, ascending: true)]
//        _categories = FetchRequest(fetchRequest: request)
//    }
    var body: some View {
        //List {
            ForEach(categories, id: \.name) { category in
                NavigationLink(destination: CategoryList(name: category.name_)) {
                    Label("\(category.name_) (\(category.booksCount))", systemImage: "books.vertical.circle.fill")
                }
            }
        //}
        //.listStyle(SidebarListStyle())
//        .navigationTitle(title)
        //.onAppear {
        //viewModel.fetchBookSubjectsFromCoreData()
        //}
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryView()
        }
    }
}


struct CategoryList: View {
    @FetchRequest private var books: FetchedResults<Book>
    @State private var selectedSort = BookSort.initial
    var name: String
    init(name: String) {
        self.name = name
        _books = FetchRequest(sortDescriptors: BookSort.initial.descriptors, predicate: NSPredicate(format: "%K CONTAINS[c] %@", "categories.name", name), animation: .default)
    }
    var body: some View {
        VStack {
            List {
                BookList(books: Array(books))
            }
            .toolbar { 
                SortSelectionView(selectedSortItem: $selectedSort, sorts: BookSort.sorts)
                    .onChange(of: selectedSort) { _ in
                        let request = books
                        request.sortDescriptors = selectedSort.descriptors
                    }
            }
            .navigationTitle(name)
        }
    }
}

//class CategoryViewModel: ObservableObject {
//    var viewContext = PersistenceController.shared.container.viewContext
//    @Published var categories: [BookCategory] = []
//    func fetchBookSubjectsFromCoreData() {
//        let request = NSFetchRequest<BookCategory>(entityName: "BookCategory")
//        request.sortDescriptors = [NSSortDescriptor(key: "booksCount", ascending: false)]
//        request.relationshipKeyPathsForPrefetching = ["books"]
//        do {
//            let cats = try self.viewContext.fetch(request)
//            categories = cats.filter({ category in
//                return !category.isSESubject
//            })
//        } catch let error {
//            print("Error fetching all books \(error)")
//        }
//    }
//}
