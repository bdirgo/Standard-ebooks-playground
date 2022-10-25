import SwiftUI
import CachedAsyncImage

struct BookList: View {
    var books: [Book] = []
    var items: [CollectionItem] = []
    init(items: [CollectionItem]) {
        self.items = items
    }
    init(books: [Book]) {
        self.books = books
    }
    var body: some View {
        if books.count > 0 {
            ForEach(books, id: \.self) { book in 
                NavigationLink { 
                    NewDetailPage(book: book)
                } label: {
                    BookListRow(book: book)
                }
            }
        } else if items.count > 0 {
            ForEach(items, id: \.self) { item in 
                if item.book != nil {
                    NavigationLink { 
                        NewDetailPage(book: item.book!)
                    } label: {
                        BookListRow(book: item.book!, position: item.position_)
                    }
                }
            }
        }
    }
}
struct BookListRow: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var book: Book
    var position: Int?
    var body: some View {
        HStack {
            if position != nil {
                Image(systemName: "\(position ?? 0).circle")
            }
            BookThumbnailImage(thumbnailUrl: book.thumbnailUrl_, hasAudiobook: book.hasAudiobook)
            VStack(alignment:.leading) {
                Text(book.title_)
                    .font(.headline)
                Text(book.firstAuthor)
                    .font(.subheadline)
            }// vstack
        } // hstack
    }
}

struct BookThumbnailImage: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    var thumbnailUrl: String
    var hasAudiobook: Bool = false
    var body: some View {
        ZStack(alignment: .topTrailing) {
            CachedAsyncImage(url: URL(string:thumbnailUrl)) { phase in 
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    VStack {
                        Image(systemName: "book.closed")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            if hasAudiobook {
                Image(systemName: "headphones.circle.fill")
                    .padding(4)
                    .background(.black)
                    .foregroundColor(.white)
            }
        }
        .frame(
            minWidth: 100,
            maxWidth: sizeClass == .compact ? 112.5 : 128,
            minHeight: 150,
            maxHeight: sizeClass == .compact ? 196 : 240
        )
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

//struct BookList_Previews: PreviewProvider {
//    static var previews: some View {
//        BookList(books: [Book]())
//    }
//}
