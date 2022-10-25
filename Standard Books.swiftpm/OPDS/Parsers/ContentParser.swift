import SwiftUI

struct EntryXML { 
    var id = "";
    var content = "";
}

struct HTMLParagraph {
    var content = ""
}

class ContentParser: NSObject, XMLParserDelegate {
    func mergeContentwith(book: inout Book) {
        let index = self.items.firstIndex { entry in
            return entry.id == book.id
        }
        if let cindex = index {
            book.content = self.items[cindex].content
        }
    }
    var items = [EntryXML]();
    var item = EntryXML();
    var paragraphs = [HTMLParagraph]();
    var foundCharacters = "";
    init(xmlData: Data) {
        super.init()
        let parser = XMLParser(data: xmlData)
        parser.delegate = self;
        parser.parse()
    }
//    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data) {
//        
//    }
//    func parser(_ parser: XMLParser, foundComment comment: String) {
//        
//    }
//    func parserDidEndDocument(_ parser: XMLParser) {
//        
//    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
//    func parserDidStartDocument(_ parser: XMLParser) {
//        
//    }
//    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
//        
//    }
//    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String) {
//        
//    }
//    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
//        
//    }
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
        self.foundCharacters = ""
    }
//    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
//        
//    }
    //    func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Data? {
    //        
    //    }
//    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
//        
//    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "id" {
            self.item.id = self.foundCharacters;
        }
        
        if elementName == "content" {
            self.item.content = self.foundCharacters;
        }
        
        if elementName == "entry" {
            var tempItem = EntryXML();
            tempItem.id = self.item.id;
            tempItem.content = self.item.content;
            self.items.append(tempItem);
        }
        if (elementName == "p") {
            self.foundCharacters = self.foundCharacters + "</p><br/><p>"
            return 
        }
        if (elementName == "i" || elementName == "a" || elementName == "abbr" || elementName == "em") {
            self.foundCharacters = self.foundCharacters + " "
            return 
        } else {
            self.foundCharacters = ""
        }
    }
//    func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {
//        
//        
//    }
//    func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
//        
//    }
//    func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
//        
//    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        if () {
//            self.foundCharacters = "" + self.foundCharacters
//        }
        if (elementName == "p" || elementName == "i" || elementName == "a" || elementName == "abbr" || elementName == "em") {
            self.foundCharacters = "" + self.foundCharacters
        }
    }
//    func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
//        
//    }
//    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
//        
//    }
//    func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
//        
//    }
}

