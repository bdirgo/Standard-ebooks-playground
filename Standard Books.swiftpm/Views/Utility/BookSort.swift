import SwiftUI

// 1
struct BookSort: Hashable, Identifiable {
    // 2
    let id: Int
    // 3
    let name: String
    // 4
    let descriptors: [SortDescriptor<Book>]
}

extension BookSort {
    static let sorts: [BookSort] = [
        // 2
        BookSort(
            id: 0,
            name: "Newest",
            // 3
            descriptors: [
                SortDescriptor(\Book.issued, order: .reverse),
                //                NSSortDescriptor(keyPath: \Book.issued, ascending: false),
                SortDescriptor(\Book.title, order: .forward),
                //                NSSortDescriptor(keyPath: \Book.title, ascending: true)
            ]),
        BookSort(
            id: 1,
            name: "Oldest",
            // 3
            descriptors: [
                SortDescriptor(\Book.issued, order: .forward),
                //                NSSortDescriptor(keyPath: \Book.issued, ascending: false),
                SortDescriptor(\Book.title, order: .forward),
                //                NSSortDescriptor(keyPath: \Book.title, ascending: true)
            ]),
        BookSort(
            id: 2,
            name: "A-Z",
            descriptors: [
                SortDescriptor(\Book.title, order: .forward)
            ]
        ),
        BookSort(
            id: 3,
            name: "Z-A",
            descriptors: [
                SortDescriptor(\Book.title, order: .reverse)
            ]
        )
//        BookSort(
//            id: 1,
//            name: "Author",
//            descriptors: [
//                SortDescriptor(\Book.authors_.first.name, order: .forward),
//                //                NSSortDescriptor(keyPath: \Book.author.name, ascending: true),
//                SortDescriptor(\Book.title, order: .forward)
//                //                NSSortDescriptor(keyPath: \Book.title, ascending: true)
//            ]),
//        BookSort(
//            id: 2,
//            name: "Longest",
//            descriptors: [
//                SortDescriptor(\Book.wordCount_, order: .reverse),
//                //                NSSortDescriptor(keyPath: \Book.wordCount, ascending: false),
//                SortDescriptor(\Book.title, order: .forward)
//                //                NSSortDescriptor(keyPath: \Book.title, ascending: true)
//            ]),
//        BookSort(
//            id: 3,
//            name: "Shortest",
//            descriptors: [
//                SortDescriptor(\Book.wordCount_, order: .forward),
//                //                NSSortDescriptor(keyPath: \Book..wordCount, ascending: true),
//                SortDescriptor(\Book.title, order: .forward)
//                //                NSSortDescriptor(keyPath: \Book.title, ascending: true)
//            ]),
//        BookSort(
//            id: 4,
//            name: "Ease",
//            descriptors: [
//                SortDescriptor(\Book.readingEase_, order: .forward),
//                //                NSSortDescriptor(keyPath: \Book.readingEase, ascending: true),
//                SortDescriptor(\Book.title, order: .forward)
//                //                NSSortDescriptor(keyPath: \Book.title, ascending: true)
//            ])
    ]
    
    // 4
    static var initial: BookSort { sorts[0] }
}
