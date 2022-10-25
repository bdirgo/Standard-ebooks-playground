//import SwiftUI
//
//struct DetailPage: View {
//    @EnvironmentObject var viewModel: ContentViewModel
//    @Environment(\.openURL) private var openURL
//    var book: Book
//    @State private var showContent = false
//    @State private var navigationSelection: String?
//    var body: some View {
//        List {
//            Section() { 
//                Button { 
//                    self.navigationSelection = book.firstAuthor
//                } label: { 
//                    TitlePage(book: book)
//                }
//                .background(
//                    NavigationLink(
//                        destination: AuthorList(authorName: book.firstAuthor),
//                        tag: book.firstAuthor,
//                        selection: $navigationSelection,
//                        label: { EmptyView() }
//                    )
//                )
//                
//            }
//            HStack {
//                Spacer()
//                Button {
//                    if let url = URL(string: book.ePubUrl_) {
//                        viewModel.didDownloadBook(book: book)
//                        openURL(url)
//                    }
//                } label: {
//                    Label("Download", systemImage: "square.and.arrow.down")
//                }
//                Spacer()
//            }
//            
//            if showContent == true {
//                Section { 
//                    Text(book.content_)
//                } header: { 
//                    HStack {
//                        Text("Summary")
//                        Spacer()
//                        Button {
//                            showContent.toggle()
//                        } label: { 
//                            Text("Close")
//                        }
//                    }
//                }
//            } else {                
//                Section { 
//                    Text(book.summary_)
//                } header: { 
//                    HStack {
//                        Text("Summary")
//                        Spacer()
//                        Button {
//                            showContent.toggle()
//                        } label: { 
//                            Text("More")
//                        }
//                    }
//                }
//            }
//            if book.subjects_.count > 0 {
//                Section("Subjects") {
//                    ForEach(book.subjects_, id: \.self) { subject in
//                        Button { 
//                            self.navigationSelection = subject.name_
//                        } label: { 
//                            Text(subject.name_)
//                        }
//                        .background(
//                            NavigationLink(
//                                destination: SubjectList(subjectName: subject.name_),
//                                tag: subject.name_,
//                                selection: $navigationSelection,
//                                label: { EmptyView() }
//                            )
//                        )
//                    }
//                }
//            }
//            if book.categories_.count > 0 {
//                Section("Categories") { 
//                    ForEach(book.categories_, id:\.self) { category in 
//                        Button { 
//                            self.navigationSelection = category.name_
//                        } label: { 
//                            Text(category.name_)
//                        }
//                        .background(
//                            NavigationLink(
//                                destination: CategoryBookList(categoryQuery: category.name_),
//                                tag: category.name_,
//                                selection: $navigationSelection,
//                                label: { EmptyView() }
//                            )
//                        )
//                    }
//                }
//            }
//        }
//        .navigationTitle(book.title_)
//        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
//    }
//}
//
//struct DetailPage_Previews: PreviewProvider {
//    static var book = ContentViewModel().fetchBook(id: "https://standardebooks.org/ebooks/theodore-roosevelt/the-rough-riders")
//    static var previews: some View {
//        NavigationView {
//            DetailPage(book: book!)
//                .environmentObject(ContentViewModel())
//        }
//    }
//}
//if book.categories_.count > 0 {
//VStack {
//Button { 
//withAnimation {
//isCategoriesExpanded.toggle()
//}
//} label: { 
//Text("Categories")
//.font(.title2)
//}
//.buttonStyle(.plain)
//ForEach(book.categories_, id:\.self) { category in 
//Button {
//self.navigationSelection = category.name_
//} label: { 
//Text(category.name_)
//}
//                        .background(
//                            NavigationLink(
//                                destination: CategoryBookList(categoryQuery: category.name_),
//                                tag: category.name_,
//                                selection: $navigationSelection,
//                                label: { EmptyView() }
//                            )
//                            .buttonStyle(.plain)
//                        )
//.frame() // like 80 height
//.clipped()
