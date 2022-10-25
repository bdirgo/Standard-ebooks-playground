import SwiftUI
struct SortSelectionView: View {
    // 1
    @Binding var selectedSortItem: BookSort
    // 2
    let sorts: [BookSort]
    var body: some View {
        // 1
        Menu {
            // 2
            Picker("Sort By", selection: $selectedSortItem) {
                // 3
                ForEach(sorts, id: \.self) { sort in
                    // 4
                    Text("\(sort.name)")
                }
            }
            // 5
        } label: {
            Label(
                "Sort",
                systemImage: "line.horizontal.3.decrease.circle")
        }
        // 6
        .pickerStyle(.inline)
    }
}

//struct SortSelectionView_Previews: PreviewProvider {
//    @State static var sort = BookSort.default
//    static var previews: some View {
//        SortSelectionView(
//            selectedSortItem: $sort,
//            sorts: BookSort.sorts)
//    }
//}
