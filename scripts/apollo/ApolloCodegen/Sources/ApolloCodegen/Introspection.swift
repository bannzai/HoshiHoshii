import Foundation
import ApolloCodegenLib

func downloadSchema() throws {
    guard let token = ProcessInfo.processInfo.environment["INTROSPECTION_GITHUB_PERSONAL_ACCESS_TOKEN"] else {
        fatalError("Unexpected INTROSPECTION_GITHUB_PERSONAL_ACCESS_TOKEN is empty or invalid URL")
    }

    let introspectionURL = URL(string: "https://api.github.com/graphql")!
    try ApolloSchemaDownloader.fetch(
        with: .init(
            using: .introspection(endpointURL: introspectionURL),
            headers: [.init(key: "Authorization", value: "Bearer \(token)")],
            outputFolderURL: schemaPath.deletingLastPathComponent()
        )
    )
}
