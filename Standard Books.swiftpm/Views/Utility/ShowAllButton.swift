import SwiftUI

struct ShowAllButton: View {
    var isToggled: Bool = false
    var action: () -> Void = {}
    var body: some View {
        Button(action: action) {
            Label("Show All", systemImage: isToggled ? "list.bullet.circle.fill" : "list.bullet.circle" )
        }
        .keyboardShortcut("a")
    }
}

struct ShowAllButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowAllButton()
    }
}

