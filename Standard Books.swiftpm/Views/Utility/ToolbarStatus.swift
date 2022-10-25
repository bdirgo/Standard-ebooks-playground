
import Foundation
import SwiftUI

struct ToolbarStatus: View {
    var isLoading: Bool
    var lastUpdated: TimeInterval
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Checking...")
                Spacer()
            } else if lastUpdated == Date.distantFuture.timeIntervalSince1970 {
                Spacer()
                Text("Newest 30 Books")
                    .foregroundStyle(Color.secondary)
            } else {
                let lastUpdatedDate = Date(timeIntervalSince1970: lastUpdated)
                Text("Last updated  \(lastUpdatedDate.formatted(.relative(presentation: .named)))")
                    .foregroundStyle(Color.secondary)
            }
        }
        .font(.caption)
    }
}

struct ToolbarStatus_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarStatus(
            isLoading: true,
            lastUpdated: Date.distantPast.timeIntervalSince1970
//            quakesCount: 10_000
        )
        
        ToolbarStatus(
            isLoading: false,
            lastUpdated: Date.distantFuture.timeIntervalSince1970
//            quakesCount: 10_000
        )
        
        ToolbarStatus(
            isLoading: false,
            lastUpdated: Date.now.timeIntervalSince1970
//            quakesCount: 10_000
        )
        
        ToolbarStatus(
            isLoading: false,
            lastUpdated: Date.distantPast.timeIntervalSince1970
//            quakesCount: 10_000
        )
    }
}
