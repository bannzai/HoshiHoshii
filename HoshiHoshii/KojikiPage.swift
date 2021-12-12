import Foundation
import SwiftUI

public struct KojikiPage: View {
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            UserProfile()
            Spacer()
                .frame(height: 10)
            RepositoryList()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct KojikiPage_Previews: PreviewProvider {
    static var previews: some View {
        KojikiPage()
            .preferredColorScheme(.dark)
    }
}