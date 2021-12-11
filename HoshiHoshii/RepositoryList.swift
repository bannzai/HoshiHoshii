import SwiftUI

public struct RepositoryList: View {
    public var body: some View {
        VStack(alignment: .center, spacing: 4) {
            RepositoryCard()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

