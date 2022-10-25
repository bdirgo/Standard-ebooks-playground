import SwiftUI
import XMLCoder

struct NewBookFeed: Codable {
    var id: String
    var links: [NewFeedLink]
    var title: String
    var subtitle: String
    var icon: String
    var updated: String?
    var authors: [NewAuthor]
    var entries: [NewFeedEntry]
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, icon, updated
        case authors = "author"
        case links = "link"
        case entries = "entry"
    }
}

struct NewFeedEntry: Codable {
    var id: String
//    var identifier: String // maybe the id that is used in github results
    var title: String
    var authors: [NewAuthor]
    var published: String?
    var issued: String
    var issuedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: issued ) ?? Date()
    }
    var updated: String?
    var language: String
    var languageLocalizedString: String? {
        let locale = NSLocale.autoupdatingCurrent
        let code = language.replacingOccurrences(of: "-", with: "_")
        return locale.localizedString(forLanguageCode: code)
    }
    var publisher: String
    var rights: String
    var summary: String
    var content: String
    var categories: [NewCategory]?
    var links: [NewFeedLink]
    var coverImage: String? {
        guard let index = links.firstIndex(where: {$0.rel == "http://opds-spec.org/image"}) else {
            return nil
        }
        return links[index].href
    }
    var thumbnailImage: String? {
        guard let index = links.firstIndex(where: {$0.rel == "http://opds-spec.org/image/thumbnail"}) else {
            return nil
        }
        return links[index].href
    }
    var thisBooksPageOnSE: String? {
        guard let index = links.firstIndex(where: {$0.rel == "alternate"}) else {
            return nil
        }
        return links[index].href
    }
    var epubCompatible: String? {
        guard let index = links.firstIndex(where: {$0.title == "Recommended compatible epub"}) else {
            return nil
        }
        return links[index].href
    }
    var epubCompatibleLength: Int? {
        guard let index = links.firstIndex(where: {$0.title == "Recommended compatible epub"}) else {
            return nil
        }
        return Int(links[index].length ?? "0")
    }
    var epubAdvanced: String? {
        guard let index = links.firstIndex(where: {$0.title == "Advanced epub"}) else {
            return nil
        }
        return links[index].href
    }
    var epubAdvancedLength: Int? {
        guard let index = links.firstIndex(where: {$0.title == "Advanced epub"}) else {
            return nil
        }
        return Int(links[index].length ?? "0")
    }
    var epubKobo: String? {
        guard let index = links.firstIndex(where: {$0.title == "Kobo Kepub epub"}) else {
            return nil
        }
        return links[index].href
    }
    var epubKoboLength: Int? {
        guard let index = links.firstIndex(where: {$0.title == "Kobo Kepub epub"}) else {
            return nil
        }
        return Int(links[index].length ?? "0")
    }
    var amazonKindle: String? {
        guard let index = links.firstIndex(where: {$0.title == "Amazon Kindle azw3"}) else {
            return nil
        }
        return links[index].href
    }
    var amazonKindleLength: Int? {
        guard let index = links.firstIndex(where: {$0.title == "Amazon Kindle azw3"}) else {
            return nil
        }
        return Int(links[index].length ?? "0")
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
//        case identifier = "dc:identifier"
        case title, published, updated, rights, summary, content
        //        case contentHTML = "content"
        case issued = "dc:issued"
        case language = "dc:language"
        case publisher = "dc:publisher"
        //        case source = "dc:source"
        case authors = "author"
        case categories = "category"
        case links = "link"
    }
//    // The keys must have the same name as the attributes of the Book entity.
//    var dictionaryValue: [String: Any] {
//        [
//            "url": id,
//            "title": title,
//            "summary": summary,
//            "ePubUrl": epubUrl?.absoluteString,
//            "coverUrl": imageUrl?.absoluteString,
//            "thumbnailUrl": thumbnailUrl?.absoluteString,
//            "issued": issuedDate,
//        ]
//    }
}


struct NewFeedLink: Codable, Equatable {
    var href: String
    var length: String?
    var rel: String
    var title: String?
    var type: String
    var id: String {
        rel + href
    }
} 

struct NewAuthor: Codable, Hashable {
    var name: String
    var uri: String?
    var alternateName: String?
    var sameAs: [String?]
    
    enum CodingKeys: String, CodingKey {
        case name, uri
        case alternateName = "schema:alternateName"
        case sameAs = "schema:sameAs"
    }
    
//    // The keys must have the same name as the attributes of the BookAuthor entity.
//    var dictionaryValue: [String: Any] {
//        [
//            "name": name,
//            "uri": uri,
//        ]
//    }
}

struct NewCategory: Codable, Hashable {
//    https://standardebooks.org/vocab/subjects for all subjects available
    var scheme: String
    var isSESubject: Bool {
        return scheme == "https://standardebooks.org/vocab/subjects"
    }
    var term: String
    
//    // The keys must have the same name as the attributes of the BookAuthor entity.
//    var dictionaryValue: [String: Any] {
//        [
//            "name": term,
//        ]
//    }
}

