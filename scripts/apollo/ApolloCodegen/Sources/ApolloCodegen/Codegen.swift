import Foundation
import ApolloCodegenLib

func codegen() throws {
    try ApolloCodegen.run(
        from: appPath,
        with: cliPath,
        options: ApolloCodegenOptions(
            includes: "schemas/graphql/*.graphql",
            namespace: nil,
            outputFormat: .multipleFiles(inFolderAtURL: appPath.appendingPathComponent("GraphQL")),
            customScalarFormat: .passthrough,
            urlToSchemaFile: schemaPath
        )
    )
}
