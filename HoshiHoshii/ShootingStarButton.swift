import SwiftUI

public struct ShootingStarButton: View {
    @Environment(\.apollo) var apollo

    @State var error: Error?

    public var body: some View {
        Button(action: shootingStar) {
            KiraKiraStar()
                .padding(.all, 8)
        }
        .handle(error: $error)
        .buttonStyle(PlainButtonStyle())
    }

    func shootingStar() {
        Task { @MainActor in
            var pageInfo: PageInfoFragment? =  nil
            var repositoryIDs: [String] = []

                do {
                    while pageInfo == nil || pageInfo?.hasNextPage == true {
                        let query = RepositoryAllQuery(after: pageInfo?.endCursor)
                        let response = try await apollo.fetchFromServer(query: query)
                        pageInfo = response.user?.repositories.pageInfo.fragments.pageInfoFragment
                        if let ids = response.user?.repositories.edges?.compactMap(\.?.node?.id) {
                            repositoryIDs.append(contentsOf: ids)
                        }
                    }

                    print("[DEBUG]", repositoryIDs.count)
                    for id in repositoryIDs.prefix(10) {
                        _ = try await apollo.perform(mutation: StarMutation(repositoryID: id))

                        let sec: UInt64 = 1_000_000_000
                        await Task.sleep(sec / 10)
                    }
                } catch {
                    self.error = error
                }

        }
    }
}


struct KiraKiraStar: View {
    @State var isEmphaszed: Bool = false

    var body: some View {
        Image(systemName: "star.fill")
            .foregroundColor(isEmphaszed ? .yellow : .yellow.opacity(0.4))
            .scaleEffect(isEmphaszed ? 1.3 : 1)
            .onAppear {
                withAnimation(.linear(duration: 0.3).repeatForever(autoreverses: true)) {
                    isEmphaszed.toggle()
                }
            }
    }
}
