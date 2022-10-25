import SwiftUI

struct OPFMetadata: Codable { 
    var id: String? // dc:identifier id="uid"
    var title: String? // dc:title id="title"
    var categories: [OPFSubject]?
    var subjects: [SESubject]?
    var collections: [SECollection]?
    var description: String? // dc:description id="description"
    var longDescription: String? // meta id="long-description" property="se:long-description" refines="#description"
    var wordCount: Int? // meta property="se:word-count"
    var readingEase: Double? // meta property="se:reading-ease.flesch
    var wikipedia: String? // meta property="se:url.encyclopedia.wikipedia
    var author: [OPFCreator]? 
    var isEmpty: Bool {
        id?.count ?? 0 < 1
    }
    
    // The keys must have the same name as the attributes of the Book entity.
    var dictionaryValue: [String: Any] {
        [
            "url": id,
            "wikipedia": wikipedia,
            "readingEase": readingEase,
            "wordCount": wordCount,
        ]
    }
    
}

struct OPFCreator: Codable {
    var name: String? // dc:creator id="author"
}

struct OPFSubject: Codable, Hashable {
    var value: String? // dc:subject id="subject-{#}"
    var index: Int? // {#}
}

struct SESubject: Codable {
    var value: String? // meta property="se:subject"
}

struct SECollection: Codable {
    var title: String? // meta id="collection-{#}" property="belongs-to-collection"
    var collectionType: String? // meta property="collection-type" refines="#collection-{#}"
    var groupPosition: Int? // meta property="group-position" refines="#collection-{#}"
    var index: Int? // {#}
    var bookId: String?
    
    // The keys must have the same name as the attributes of the CollectionItem entity.
    var itemDictionaryValue: [String: Any] {
        [
            "name": title,
            "rank": index,
            "position": groupPosition,
            "bookId": bookId,
        ]
    }
    
    // The keys must have the same name as the attributes of the BookCollection entity.
    var collectionDictionaryValue: [String: Any] {
        [
            "name": title,
            "type": collectionType
        ]
    }
}

extension String {
    var decoded: String {
        let attr = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil)
        
        return attr?.string ?? self
    }
}

class OPFParser: NSObject, XMLParserDelegate {
    func mergeContentwith(book: inout Book) {
        if book.id == itemMetadata.id {
//            TODO:
//            Add Wikipeida
//            word count
//            reading ease
//            collections
//            to the Book Core Data 
        }
    }
    // dc:identifier id="uid"
    var isIdElement = false
    // meta id="long-description" property="se:long-description" refines="#description"
    var isLongDescriptionElement = false
    // meta property="se:word-count"
    var isWordCountElement = false
    // meta property="se:reading-ease.flesch
    var isReadingEaseElement = false
    // meta property="se:url.encyclopedia.wikipedia
    var isWikipediaElement = false
    // meta id="collection-{#}" property="belongs-to-collection"
    var isCollectionElement = false
    // meta property="collection-type" refines="#collection-{#}"
    var isCollectionTypeElement = false
    // meta property="group-position" refines="#collection-{#}"
    var isCollectionPosistionElement = false
    
    var bookId = ""
    var itemMetadata = OPFMetadata();
    var collections = [SECollection]();
    var foundCharacters = "";
    var foundCollectionIndex: Int = 1
    
    init(xmlData: Data, bookId: String) {
        super.init()
        let parser = XMLParser(data: xmlData)
        self.bookId = bookId
        parser.delegate = self;
        
        parser.parse()
    }
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
        
    }
    func parser(_ parser: XMLParser, foundComment comment: String) {
        
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        
    }
    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {
        
    }
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        
    }
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
        self.foundCharacters = ""
    }
    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        
    }
    //    func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Data? {
    //        
    //    }
    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
        
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if isIdElement {
            self.itemMetadata.id = self.foundCharacters
        }
        if isLongDescriptionElement {
            self.itemMetadata.longDescription = self.foundCharacters
        }
        if isWikipediaElement {
            self.itemMetadata.wikipedia = self.foundCharacters
        }
        if isWordCountElement {
            self.itemMetadata.wordCount = Int(self.foundCharacters)
        }
        if isReadingEaseElement {
            self.itemMetadata.readingEase = Double(self.foundCharacters)
        }
        if isCollectionElement {
            var currentCollection = SECollection();
            currentCollection.index = self.foundCollectionIndex
            currentCollection.title = self.foundCharacters
            currentCollection.bookId = self.bookId
            self.collections.append(currentCollection);
        }
        if isCollectionTypeElement {
            let index = self.collections.firstIndex { collection in
                return self.foundCollectionIndex == collection.index ?? 0
            }
            if let i = index {
                //print(self.foundCharacters)
                self.collections[i].collectionType = self.foundCharacters
            }
        }
        if isCollectionPosistionElement {
            let index = self.collections.firstIndex { collection in
                return self.foundCollectionIndex == collection.index ?? 0
            }
            if let i = index {
                let stringArray = self.foundCharacters.components(separatedBy: CharacterSet.decimalDigits.inverted)
                for item in stringArray {
                    if let number = Int(item) {
                        self.collections[i].groupPosition = number
                    }
                }
            }
        }
    }
    func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {
        
        
    }
    func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
        
    }
    func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
        
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // dc:identifier id="uid"
        if (elementName == "dc:identifier" && attributeDict["id"] == "uid") {
            isIdElement = true
        } else {
            isIdElement = false
        }
        // meta id="long-description" property="se:long-description" refines="#description"
        if (elementName == "meta" && attributeDict["id"] == "long-description") {
            isLongDescriptionElement = true
        } else {
            isLongDescriptionElement = false
        }
        // meta property="se:word-count"
        if (elementName == "meta" && attributeDict["property"] == "se:word-count") {
            isWordCountElement = true
        } else {
            isWordCountElement = false
        }
        // meta property="se:reading-ease.flesch
        if (elementName == "meta" && attributeDict["property"] == "se:reading-ease.flesch") {
            isReadingEaseElement = true
        } else {
            isReadingEaseElement = false
        }
        // meta property="se:url.encyclopedia.wikipedia
        if (elementName == "meta" && attributeDict["property"] == "se:url.encyclopedia.wikipedia" && attributeDict["refines"] == "#author") {
            isWikipediaElement = true
        } else {
            isWikipediaElement = false
        }
        // meta id="collection-{#}" property="belongs-to-collection"
        if (elementName == "meta" && attributeDict["id"]?.contains("collection") != nil && attributeDict["property"] == "belongs-to-collection") {
            isCollectionElement = true
            let string = attributeDict["id"] ?? ""
            let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            for item in stringArray {
                if let number = Int(item) {
                    self.foundCollectionIndex = number
                }
            }
        } else {
            isCollectionElement = false
        }
        // meta property="collection-type" refines="#collection-{#}"
        if (elementName == "meta" && attributeDict["property"] == "collection-type") {
            isCollectionTypeElement = true
            let string = attributeDict["refines"] ?? ""
            let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            for item in stringArray {
                if let number = Int(item) {
                    self.foundCollectionIndex = number
                }
            }
        } else {
            isCollectionTypeElement = false
        }
        // meta property="group-position" refines="#collection-{#}"
        if (elementName == "meta" && attributeDict["property"] == "group-position") {
            isCollectionPosistionElement = true
            let string = attributeDict["refines"] ?? ""
            let stringArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            for item in stringArray {
                if let number = Int(item) {
                    self.foundCollectionIndex = number
                }
            }
        } else {
            isCollectionPosistionElement = false
        }
        self.foundCharacters = ""
    }
    func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
        
    }
    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        
    }
    func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
        
    }
}
