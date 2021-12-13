import Foundation
import SwiftUI
import UserNotifications

public struct KojikiPage: View {
    @Environment(\.apollo) var apollo
    @EnvironmentObject var pushNotification: PushNotification

    @State var repositories: [RepositoryCardFragment] = []
    @State var userProfile: UserProfileFragment?
    @State var pageInfo: PageInfoFragment?
    @State var error: Error?

    public var body: some View {
        NavigationView {
            NoDecorationList {
                if let userProfile = userProfile {
                    UserProfile(fragment: userProfile)
                }

                ForEach(repositories) { repository in
                    VStack(spacing: 0) {
                        RepositoryCard(fragment: repository)
                        Spacer().frame(height: 8)
                    }
                    .task {
                        if let pageInfo = pageInfo, pageInfo.hasNextPage {
                            if repositories.last?.id == repository.id {
                                await request()
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .top)
            }
            .task {
                await request()

            }
            .refreshable {
                await refresh()
            }
            .navigationTitle(Text("Kojiki"))
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ShootingStarButton()
                }
            })
        }
    }

    private func request() async {
        let query = BannzaiRepositoriesQuery(after: pageInfo?.endCursor)

        do {
            setResponse(try? await apollo.fetchFromCache(query: query))
            setResponse(try await apollo.fetchFromServer(query: query))
        } catch {
            self.error = error
        }

        Task { @MainActor in
            do {
                for try await response in apollo.watch(query: query) {
                    setResponse(response)
                }
            } catch {
                print(error)
            }
        }
    }

    private func refresh() async {
        let query = BannzaiRepositoriesQuery(after: nil)

        do {
            let response = try await apollo.fetchFromServer(query: query)

            userProfile = nil
            repositories = []
            pageInfo = nil

            setResponse(response)
        } catch {
            self.error = error
        }
    }

    private func setResponse(_ data: BannzaiRepositoriesQuery.Data?) {
        guard let data = data else {
            return
        }
        if let userProfileFragment = data.user?.fragments.userProfileFragment {
            userProfile = userProfileFragment
        }
        if let repositoryCardFragments = data.user?.repositories.edges?.compactMap(\.?.node?.fragments.repositoryCardFragment) {
            let copied = repositories
            repositories = repositoryCardFragments.reduce(into: copied) { partialResult, repositoryCardFragment in
                if let index = partialResult.firstIndex(where: { $0.id == repositoryCardFragment.id }) {
                    partialResult[index] = repositoryCardFragment
                } else {
                    partialResult.append(repositoryCardFragment)
                }
            }
        }
        if let pageInfoFragment = data.user?.repositories.pageInfo.fragments.pageInfoFragment {
            pageInfo = pageInfoFragment
        }
    }
}

struct KojikiPage_Previews: PreviewProvider {
    static var previews: some View {
        KojikiPage()
            .preferredColorScheme(.dark)
    }
}
