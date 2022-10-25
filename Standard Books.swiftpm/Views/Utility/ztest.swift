//import SwiftUI
//
//func testHTML() -> [AttributedString] {
//    let testString = """
//    <p>first paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapghfirst paragrapgh</p>
//    <p>second paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapghsecond paragrapgh</p>
//    """
//    let testArr = testString.components(separatedBy: "</p>")
//    var contentText: [AttributedString] = []
//    for str in testArr {
//        guard let htmlData = str.data(using: .utf16) else {
//            print("utf16 failed")
//            contentText.append(AttributedString(str))
//            return contentText
//        }
//        if let nsAttributedString = try? NSMutableAttributedString(data: htmlData, options: [
//            .documentType: NSAttributedString.DocumentType.html,
//        ], documentAttributes: nil) {
//            print("attributed string worked")
//            contentText.append(AttributedString(nsAttributedString))
////            contentText.mergeAttributes(attrContainer)
//        } else {
//            print("mutable string failed")
//            contentText.append(AttributedString(str))
//        }
//    }
//    return contentText
//}
//
//struct someView: View {
//    var body: some View {
//        ForEach(testHTML(), id: \.self) { str in
//            Text(str)
//        }
//    }
//}
//
//struct MyPreviewProvider_Previews: PreviewProvider {
//    static var previews: some View {
//        someView()
//    }
//}
