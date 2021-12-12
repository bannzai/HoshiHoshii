import Foundation

// TODO: Remove
struct Identity<T>: Identifiable {
    let id = UUID()
    let value: T

    init(_ value: T) {
        self.value = value
    }
}

extension Identity: Error, LocalizedError where T: Error {
    var error: Error { value }

    var errorDescription: String? {
        error.localizedDescription
    }
    // TODO:
    var failureReason: String? { nil }
    var recoverySuggestion: String? { nil }
    var helpAnchor: String? { nil }
}

