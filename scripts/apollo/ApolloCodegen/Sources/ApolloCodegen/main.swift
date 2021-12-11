import Foundation

print("Launched ApolloCodegen process...")

let cwd = URL(string: "file://\(FileManager.default.currentDirectoryPath)")!
print("cwd: ", cwd)

let cliPath = cwd.appendingPathComponent("ApolloCLI")
print("ApolloCodegen CLI binary path of \(cliPath.absoluteString)")

let schemaPath = cwd.appendingPathComponent("schema.graphqls")
print("ApolloCodegen will download and use schema path of \(schemaPath.absoluteString)")

let appPath = cwd // ApolloCodegen
    .deletingLastPathComponent() // apollo
    .deletingLastPathComponent() // scripts
    .deletingLastPathComponent() // Posusume
print("Defined application path: \(appPath)")

do {
    print("Begin downloadSchema...")
    try downloadSchema()
} catch {
    fatalError("downloadSchema failed. details: \(error))")
}
print("End downloadSchema")

do {
    print("Begin codegen...")
    try codegen()
} catch {
    fatalError("codegen failed. details: \(error))")
}

print("End codegen")
print("End ApolloCodegen")
