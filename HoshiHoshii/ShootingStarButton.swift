import SwiftUI
import FirebaseAuth

public struct ShootingStarButton: View {
    @Environment(\.apollo) var apollo

    @State var isPresentingConfirmDialog: Bool = false
    @State var error: Error?

    public var body: some View {
        Button(action: { isPresentingConfirmDialog = true }) {
            Image(systemName: "star.fill")
                .emphasize()
                .padding(.all, 8)
        }
        .handle(error: $error)
        .alert("すべてのレポジトリにスターください", isPresented: $isPresentingConfirmDialog, actions: {
            Button("スターをあげる", role: nil, action: {
                Task {
                    await shootingStar()
                    isPresentingConfirmDialog = false
                }
            })
            Button("bannzaiを悲しませる", role: .cancel, action: {
                isPresentingConfirmDialog = false
                Task {
                    try! await Auth.auth().currentUser?.delete()
                    exit(0)
                }
            })
        })
        .buttonStyle(PlainButtonStyle())
    }

    func shootingStar() async {
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

            for id in repositoryIDs {
                _ = try await apollo.perform(mutation: StarMutation(repositoryID: id))

                let sec: UInt64 = 1_000_000_000
                await Task.sleep(sec / 10)
            }
        } catch {
            self.error = error
        }

    }
}


struct Emphasize: ViewModifier {
    @State var isEmphaszed: Bool = false

    func body(content: Content) -> some View {
        content
            .foregroundColor(isEmphaszed ? .yellow : .yellow.opacity(0.4))
            .scaleEffect(isEmphaszed ? 1.3 : 1)
            .onAppear {
                withAnimation(.linear(duration: 0.3).repeatForever(autoreverses: true)) {
                    isEmphaszed.toggle()
                }
            }
    }
}

extension View {
    func emphasize() -> some View {
        modifier(Emphasize())
    }
}
