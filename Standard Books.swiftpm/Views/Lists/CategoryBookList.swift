//import SwiftUI
//import CoreData
//
//struct CategoryBookList: View {
//    @EnvironmentObject var viewModel: ContentViewModel
//    var categoryQuery: String
//    var body: some View {
//        VStack {
//            List {
//                BookList(books: viewModel.currentCategory.first?.books_ ?? [])
//            }
//            .onAppear { viewModel.fetchBooksForCategory(name: categoryQuery) }
//            .navigationTitle(categoryQuery)
//            
//        }
//    }
//}
//struct CategoryList_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryBookList(categoryQuery: "Fiction")
//            .environmentObject(ContentViewModel())
//    }
//}
