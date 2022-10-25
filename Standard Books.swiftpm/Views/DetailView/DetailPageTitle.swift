import SwiftUI
import CachedAsyncImage

struct DetailPageTitle:View {
//    @EnvironmentObject private var viewModel: DetailPageViewModel
//    @State private var didAdd: Bool = false
    
    var book: Book
    init(book: Book) {
//        _didAdd = State(initialValue: book.didAdd)
        self.book = book
    }
    var body: some View {
        AdaptiveStack {
            BookImage(book: book)
                .frame(width: 256, height: 384)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom)
            Spacer()
            LazyVStack {
                if let series = book.collectionItems_.first {
                    NavigationLink(destination: CollectionList(collectionName: series.name_)) {
                        Text(series.name_)
                            .underline()
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom)
                }
                Text(book.title_)
                    .font(.title)
                    .padding(.bottom)
                AuthorButtons(book: book)
                    .font(.caption)
                    .padding(.bottom)
                VStack {
                    HStack {
                        Spacer()
                        DownloadButton(book: book)
                        Spacer()
                    }
                    ShareBookButton(book: book)
                }
                .padding(.bottom)
            }
            Spacer()
        }
    }
}

struct BookImage: View {
    var book: Book
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            CachedAsyncImage(url: URL(string: book.coverUrl_)) { image in
                image.resizable() 
                    .scaledToFit()
            } placeholder: {
                Color.accentColor
            }
            if book.hasAudiobook {
                Image(systemName: "headphones.circle.fill")
                    .padding(4)
                    .background(.black)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
            }
        }
    }
}

struct AuthorButtons: View {
    var book: Book
    var body: some View {
        ForEach(book.authors_, id: \.self) { author in
            NavigationLink(destination: AuthorList(authorName: author.name_)) {
                Text(author.name_)
                    .underline()
            }
            .buttonStyle(.plain)
        }
    }
}

// 2. Share Text
struct ShareURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct DownloadButton: View {
//    @EnvironmentObject var viewModel: DetailPageViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var downloader: DownloadManager
    var book: Book
    var showShare: Bool {
        downloader.checkFileExists(file: book.fileName)
    }
    @State private var removed = false
    @State private var shareURL: ShareURL?
    var body: some View {
        if showShare && !removed {
            HStack {
                Button {
                    Task {
                        if let url = downloader.fileURL(for: book.fileName) {
                            shareURL = ShareURL(url: url)
                        }
                    }
                } label: {
                    Label("Open book", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                // 5. Sheet to display Share Text
                .sheet(item: $shareURL) { shareURL in
                    ActivityView(url: shareURL.url)
                }
                Button(role: .destructive) {
                    Task {
                        try downloader.removeFile(file: book.fileName)
                        removed = true
                    }
                } label: {
                    Label("Remove", systemImage: "trash")
                }
                .buttonStyle(.borderedProminent)
            }
        } else {
            if downloader.isDownloading {
                Label("Downloading", systemImage: "rectangle.and.pencil.and.ellipsis")
            } else {
            Button {
                if !downloader.isDownloading {
//                    viewModel.didAddBook(book: book, true)
                    print("added")
                    if let url = URL(string: book.ePubUrl_) {
                        print(url)
                        removed = false
                        Task {
                            try await downloader.download(file: book.fileName, from: url)
                            
                        }
                    }
                }
            } label: {
                Label("Download", systemImage: "icloud.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
            .foregroundColor(colorScheme == .dark ? .black : .white)
            }
        }
    }
}

struct ShareBookButton: View {
    var book:Book
    @State private var shareURL: ShareURL?
    var body: some View {
        Button {
            let url = URL(string: book.url)
            shareURL = ShareURL(url: url!)
        } label: { 
            Label("Share link", systemImage: "square.and.arrow.up")
        }
        .sheet(item: $shareURL) { shareURL in
            ActivityView(url: shareURL.url)
        }
    }
}

//struct WantToReadButton: View {
//    @EnvironmentObject var viewModel: DetailPageViewModel
//    @Binding var didAdd: Bool
//    var book: Book
//    
//    var body: some View {
//        if didAdd {
//            Button {
//                didAdd.toggle()
//                viewModel.didAddBook(book: book, false)
//            } label: {
//                Label("Added to Home", systemImage: "checkmark")
//            }
//        } else {
//            Button {
//                didAdd.toggle()
//                viewModel.didAddBook(book: book, true)
//            } label: {
//                Label("Want to Read", systemImage: "plus")
//            }
//        }
//    }
//}
