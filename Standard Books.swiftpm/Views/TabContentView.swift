import SwiftUI

struct TabContentView: View {
    @State private var homeTabId = UUID()
    @State private var newestTabId = UUID()
    @State private var browseTabId = UUID()
    @State private var searchTabId = UUID()
    @State private var tabSelection = 1
    @State private var tappedTwice = false
    var handler: Binding<Int> { Binding(
        get: { self.tabSelection },
        set: {
            if $0 == self.tabSelection {
                tappedTwice = true
            }
            self.tabSelection = $0
        }
    );}
    var body: some View {
        TabView(selection: handler) {
//            NavigationView {
//                HomeView()
//                    .id(homeTabId)
//                    .onChange(of: tappedTwice, perform: { tappedTwice in
//                        guard tappedTwice else { return }
//                        homeTabId = UUID()
//                        self.tappedTwice = false
//                    })
//            }
//            .tabItem {
//                Label("Home", systemImage: "house")
//            }
//            .tag(0)
            NavigationView {
                NewestReleasesView()
                    .id(newestTabId)
                    .onChange(of: tappedTwice, perform: { tappedTwice in
                        guard tappedTwice else { return }
                        newestTabId = UUID()
                        self.tappedTwice = false
                    })
            }
//            .badge(2) // TODO: give an update on how many new books there are
            .tabItem {
                Label("New", systemImage: "tray.and.arrow.down.fill")
            }
            .tag(1)
            NavigationView {
                BrowseView()
                    .id(browseTabId)
                    .onChange(of: tappedTwice, perform: { tappedTwice in
                        guard tappedTwice else { return }
                        browseTabId = UUID()
                        self.tappedTwice = false
                    })
            }
            .tabItem {
                Label("Browse", systemImage: "books.vertical")
            }
            .tag(2)
//            NavigationView {
//                SearchView()
//                    .id(searchTabId)
//                    .onChange(of: tappedTwice, perform: { tappedTwice in
//                        guard tappedTwice else { return }
//                        searchTabId = UUID()
//                        self.tappedTwice = false
//                    })
//            }
//            .tabItem {
//                Label("Search", systemImage: "magnifyingglass")
//            }
//            .tag(3)
        }
    }
}
