import Foundation

// TODO: Remove
struct Identity<T>: Identifiable {
    let id = UUID()
    let value: T

    init(_ value: T) {
        self.value = value
    }
}

extension Identity: Error where T: Error {
    var error: Error {
        value
    }
}

