import SwiftUI

struct AudioBook: View {
    @StateObject var viewModel = AudioBookViewModel()
    var book: Book
    var body: some View {
        VStack {
            if let audiobook = viewModel.audiobookResults.first {
                Text("View Audiobbook on LibriVox")
                    .font(.headline)
//                ForEach(viewModel.audiobookResults, id:\.self) { book in
                    MyLink(audiobookResults: audiobook ?? LibriVox.Books(id: "0", title: "", language: "", urlLibrivox: "", totaltimesecs: 0))
//                }
            }
            Text("")
        }
        .onAppear {
            Task {
//                if !book.hasAudiobook {
                try await viewModel.fetchLibrivox(title:book.title_, book: book)
//                }
            }
        }
    }
}

struct MyLink: View {
    var audiobookResults: LibriVox.Books
    var body: some View {
        Link(destination: 
                URL(string: audiobookResults.appUrl) 
             ?? URL(string: audiobookResults.urlLibrivox)
             ?? URL(string: "https://librivox.org/")!
        ) {
            HStack {
                Image(systemName: "headphones")
                VStack(alignment:.leading){
                    Spacer()
                    Text("\(audiobookResults.title)")
                        .fontWeight(.bold)
                    Text("\(audiobookResults.totalTimeFormatted)")
                    Text("\(audiobookResults.language)")
                    Spacer()
                }
                Image(systemName: "arrowshape.turn.up.right")
            }
            .padding()
            .foregroundColor(Color.primary)
//            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 2)
            )
        }
    }
}

struct LibriVox: Codable {
    static func searchUrl(title: String) -> String {
        return "https://librivox.org/api/feed/audiobooks/?title=\(title)&format=json"
        //        "&fields={title,language,url_librivox,totaltimesecs,authors}" // fields dont work for some reason
    }
    var books: [Books] = []
    struct Books: Codable, Hashable {
        var id: String
        var title: String
        var url_text_source: String?
        var language: String
        var copyright_year: String?
        var num_sections: String?
        var url_rss: String?
        var url_zip_file: String?
        var url_project: String?
        var urlLibrivox: String
        var appUrl: String {
            var components = URLComponents()
            components.scheme = "https"
            components.host = URL(string: "https://librivox.app")?.host
            components.path = "/book/\(id)"
            return components.string ?? ""
        }
        var totaltimesecs: Int
        var totalTimeFormatted: String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            
            let formattedString = formatter.string(from: TimeInterval(totaltimesecs))!
            return formattedString
        }
        var authors: [Authors] = []
    }
    struct Authors: Codable, Hashable {
        var id: String
        var firstName: String
        var lastName: String
        var dob: String
        var dod: String
        var fullName: String {
            return "\(firstName) \(lastName)"
        }
    }
//    {"books":[{"id":"219","title":"Northanger Abbey","description":"Northanger Abbey is a hilarious parody of 18th century gothic novels. The heroine, 17-year old Catherine, has been reading far too many \u201chorrid\u201d gothic novels and would love to encounter some gothic-style terror \u2014 but the superficial world of Bath proves hazardous enough. (Summary by Kara)","url_text_source":"https:\/\/www.gutenberg.org\/etext\/121","language":"English","copyright_year":"1803","num_sections":"31","url_rss":"https:\/\/librivox.org\/rss\/219","url_zip_file":"https:\/\/www.archive.org\/download\/northanger_abbey_librivox\/northanger_abbey_librivox_64kb_mp3.zip","url_project":"https:\/\/en.wikipedia.org\/wiki\/Northanger_Abbey","url_librivox":"https:\/\/librivox.org\/northanger-abbey-by-jane-austen\/","url_other":"","totaltime":"8:12:02","totaltimesecs":29522,"authors":[{"id":"155","first_name":"Jane","last_name":"Austen","dob":"1775","dod":"1817"}]}]}
}

class AudioBookViewModel: ObservableObject {
    @Published var audiobookResults: [LibriVox.Books?] = []
    @Environment(\.managedObjectContext) private var viewContext
    var booksProvider: PersistenceController = .shared
    func fetchLibrivox(title: String, book: Book) async throws {
        let searchUrl = LibriVox.searchUrl(title: title.mixedPlusCased())
        print(searchUrl)
        guard let url = URL(string: searchUrl) else { return }
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw SEError.missingData
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let results = try decoder.decode(LibriVox.self, from: data)
            let firstbook = results.books.filter { b in
                b.language == "English"
            }.first
            if (firstbook != nil) {
                audiobookResults = [firstbook]
                try await booksProvider.createRelationship(for: firstbook!, and: book.id)
////                book.audiobook = librivoxBook
//                let objectID = book.objectID
//                let bookCopy = viewContext.object(with: objectID)
//                librivoxBook.book = bookCopy as? Book
//                try viewContext.save()
            }
        }
    }
}

