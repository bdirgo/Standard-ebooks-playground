import SwiftUI

struct DetailPageLinks: View {
//    @EnvironmentObject private var viewModel: DetailPageViewModel
    @State private var navigationSelection: String?
    @State private var isSubjectsExpanded = false
    @State private var isCategoriesExpanded = false
    @State private var isCollectionsExpanded = false
    var buttonHeight: CGFloat = 120
    var book: Book
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment:.top,  spacing: 20) {
                if let subject = book.firstUniqueSubject {
                    FirstSubjectLink(navigationSelection: $navigationSelection, subject: subject)
                }
                Divider()
                IssuedAt(book:book)
                Divider()
                if book.wordCount_ > 0 {
                    WordCount(book: book)
                    Divider()
                }
                PublishedBy(book: book)
                Divider()
                BookFileSize(book: book)
                Divider()
                LanguageOf(book: book)
//                Divider()
//                if book.wikipedia_.count > 0 {
//                    Link("Wikipedia for \(book.firstAuthor)", destination: URL(string: book.wikipedia_) ?? URL(string: "https://www.wikipedia.org")!)
//                    //                    .padding(.bottom)
//                    //                Spacer()
//                }
                
//                if book.collectionItems_.count > 1 {
//                    VStack {
//                        //                    Button { 
//                        //                        withAnimation {
//                        //                            isCollectionsExpanded.toggle()
//                        //                        }
//                        //                    } label: { 
//                        Text("Collections")
//                            .font(.title2)
//                        //                    }
//                        //                    .buttonStyle(.plain)
//                        ForEach(book.collectionItems_, id:\.self) { collection in 
//                            Button {
//                                self.navigationSelection = collection.name_
//                            } label: { 
//                                Text(collection.name_)
//                            }
//                            .background(
//                                NavigationLink(
//                                    destination: CollectionList(collectionName: collection.name_),
//                                    tag: collection.name_,
//                                    selection: $navigationSelection,
//                                    label: { EmptyView() }
//                                )
//                                .buttonStyle(.plain)
//                            )
//                        }
//                    }
//                    .frame(maxHeight: isCategoriesExpanded ? nil : buttonHeight, alignment: .top)
//                    .clipped()
//                    //                Spacer()
//                    
//                }
            }
            .padding(.bottom)
        }
//        .onAppear {
//            if book.wordCount == nil || book.readingEase == nil {
//            }
//        }
    } 
}

struct LinkTitle: View {
    var text = ""
    var body: some View {
        Text(text)
            .font(.lowercaseSmallCaps(.caption)())
            .fontWeight(.light)
            .padding(.bottom, 4)
    }
}

struct FirstSubjectLink: View {
    @Binding var navigationSelection: String?
    var subject: BookSubject 
    var body: some View {
        VStack {
            LinkTitle(text: "Subject")
            Button {
                self.navigationSelection = subject.name_
            } label: { 
                SubjectButton(subject: subject)
            }
            .foregroundColor(.accentColor)
            .buttonStyle(.plain)
            .background(
                NavigationLink(
                    destination: SubjectList(name: subject.name_),
                    tag: subject.name_,
                    selection: $navigationSelection,
                    label: { EmptyView() }
                )
                .buttonStyle(.plain)
            )
        }
    }
}

struct PublishedBy: View {
    var book: Book
    var body: some View {
        VStack {
            LinkTitle(text: "Publisher")
            Link(destination: URL(string: book.url)!) { 
                Text("Standard Ebooks")
                    .font(.caption2)
            }
            .foregroundColor(.accentColor)
            .buttonStyle(.plain)
        }
    }
}

struct BookFileSize: View {
    var book: Book
    var body: some View {
        VStack {
            LinkTitle(text: "Filesize")
            Text(book.ePubFileSize)
                .fontWeight(.bold)
            Text("ePub")
        }
    }
}

struct LanguageOf: View {
    var book: Book
    var language: String
    var region: String
    init(book: Book) {
        self.book = book
        let currentLocale = Locale(identifier: Locale.current.identifier)
        self.language = currentLocale.localizedString(forLanguageCode: book.language_) ?? ""
        self.region = Locale(identifier: book.language_).localizedString(forRegionCode: Locale(identifier: book.language_).regionCode ?? "us") ?? ""
        
    }
    var body: some View {
        VStack {
            LinkTitle(text: "Language")
            Text(language)
                .fontWeight(.bold)
            Text(region)
                .font(.caption2)
        }
    }
}

struct IssuedAt: View {
    var book: Book
    var dateString: String
    var yearString: String
    init(book: Book) {
        self.book = book
        
        let dateFormatter = DateFormatter()
        let yearFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        yearFormatter.locale = Locale(identifier: Locale.current.identifier)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd")
        yearFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        
        self.yearString = yearFormatter.string(from: book.issued_)
        self.dateString = dateFormatter.string(from: book.issued_)
    }
    var body: some View {
        VStack {
            LinkTitle(text: "Issued")
            Text(self.yearString)
                .fontWeight(.bold)
            Text(self.dateString)
                .font(.caption2)
        }
    }
}

//struct PublishedBy_Previews: PreviewProvider {
//    static var previews: some View {
//        PublishedBy()
//    }
//}

struct SubjectButton: View {
    var subject: BookSubject
    var body: some View {
        VStack {
            Image(systemName: subject.symbolName_)
            Text(subject.name_)
        }
    }
}

struct WordCount: View {
    var book: Book
    var body: some View {
        VStack {
            LinkTitle(text:"Words")
            Text("\(book.wordCount_)")
                .fontWeight(.bold)
            ReadingEase(book: book)
                .font(.caption2)
        }
    }
}

struct ReadingEase: View {
    var book: Book
    var body: some View {
        Text("\(book.readingEaseString)")
    }
}


