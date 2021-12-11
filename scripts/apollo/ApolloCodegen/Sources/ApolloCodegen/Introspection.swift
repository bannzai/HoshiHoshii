import Foundation
import ApolloCodegenLib

func downloadSchema() throws {
    guard let introspectionURLString = ProcessInfo.processInfo.environment["APP_GRAPHQL_API_INTROSPECTION_URL"],
          let introspectionURL = URL(string: introspectionURLString) else {
        fatalError("Unexpected APP_GRAPHQL_API_INTROSPECTION_URL is empty or invalid URL")
    }
    print("Put schema file from \(introspectionURLString) to \(schemaPath.absoluteString)")

    try ApolloSchemaDownloader.fetch(
        with: .init(
            using: .introspection(endpointURL: introspectionURL),
            outputFolderURL: schemaPath.deletingLastPathComponent()
        )
    )
}
