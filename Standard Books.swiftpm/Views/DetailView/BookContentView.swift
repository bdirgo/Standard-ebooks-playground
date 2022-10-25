import SwiftUI


struct BookContentView: View {
//    @EnvironmentObject private var viewModel: DetailPageViewModel
    @State private var isExpanded = false
    var maxHeight: CGFloat = 120
    var contentText: AttributedString
    var book: Book
    
    init(book: Book, colorScheme: ColorScheme) {
        self.book = book
        let html = book.content_.replacingOccurrences(of: "</p>", with: "</p>&#8233;") // its stupid but it works
        guard let htmlData = html.data(using: .utf16) else {
            print("utf16 failed")
            contentText = AttributedString(html)
            return
        }
        
        if let nsAttributedString = try? NSMutableAttributedString(data: htmlData, options: [
            .documentType: NSAttributedString.DocumentType.html,
        ], documentAttributes: nil) {
//            print("attributed string worked")
            switch colorScheme {
            case .dark: 
                nsAttributedString.setFontFace(font: UIFont.preferredFont(from: .body), color: .white)
            case .light:
                nsAttributedString.setFontFace(font: UIFont.preferredFont(from: .body), color: .black)
            default:
                break
            }
            contentText = AttributedString(nsAttributedString)
        } else {
            print("mutable string failed")
            contentText = AttributedString(html)
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                    Text(contentText)
                        .padding(.bottom)
                        .textSelection(.enabled)
            }
            .frame(maxHeight: isExpanded ? nil : maxHeight, alignment: .top)
            .clipped()
            
            Button { 
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                if isExpanded {
                    Label("Less", systemImage: "chevron.up")
                } else {
                    Label("More", systemImage: "chevron.down")                    
                }
            }
            .buttonStyle(.plain)
        }
    }
}
