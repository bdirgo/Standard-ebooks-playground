import SwiftUI


struct MoreForThisBook: View {
    @Environment(\.managedObjectContext) private var viewContext
    var showForYou: Bool {
        self.moreByThisAuthor.count + self.moreOfThisCategory.count > 0
    }
    var moreAuthorText: String {
        "More by \(self.moreByThisAuthor.first?.firstAuthor ?? "this author")"
    }
    var moreByThisAuthor: [Book] {
        let authorBooks = book.authors_.first?.books_ ?? []
        if authorBooks.count > 1 {
            return authorBooks
        }
        return []
    }
    // todo: make this a featch request
    var moreOfThisCategory: [Book] {
        let categories = book.categories_.first?.books_ ?? []
        if categories.count > 1 {
            return categories
        }
        return []
    }
    var moreCategoryName: String {
        let categories = book.categories_.first?.books_ ?? []
        if categories.count > 1 {
            return book.categories_.first?.name_ ?? "Category"
        }
        return "Category"
    }
    
    var book: Book
    var body: some View {
        VStack(alignment:.leading) {
            if showForYou {
                if moreByThisAuthor.count > 0 {
                    Divider()
                        .padding(.bottom)
                    VStack(alignment: .leading) {
                        NavigationLink(destination: List {
                            BookList(books: moreByThisAuthor)
                                .navigationTitle(moreAuthorText)
                                .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                        }){
                            Text(moreAuthorText)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                        HorizontalBookList(bookArray: moreByThisAuthor.filter({ 
                            $0.id != book.id
                        }))
                    }
                }
                if moreOfThisCategory.count > 0 {
                    Divider()
                        .padding(.bottom)
                    VStack(alignment: .leading) {
                        NavigationLink(destination: List {
                            BookList(books: moreOfThisCategory)
                                .navigationTitle(moreCategoryName)
                                .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
                        }){
                            Text(moreCategoryName)
                                .font(.title3)
                        }
                        .buttonStyle(.plain)
                        HorizontalBookList(bookArray: moreOfThisCategory.filter({ 
                            $0.id != book.id
                        }))
                    }
                
                }
            }
            if (book.collectionItems_.count > 0) {
                Text("Collections")
                    .font(.headline)
                ForEach(book.collectionItems_, id:\.self) { item in 
                    Text(item.name_)
                }
            }
            if (book.categories_.count > 0) {
                Text("Categories")
                    .font(.headline)
                ForEach(book.categories_, id:\.self) { category in 
                    Text(category.name_)
                }
            }
        }
    }
}
