import Foundation
import SwiftUI
import FirebaseAuth

@MainActor final class AppViewModel: ObservableObject {
    @Published var me: Me?
    @Environment(\.apollo) var apollo

    func signIn() async throws {
        let credential = try await _githubCredential()
        let info = try await _signIn(with: credential)
        let me = Me(id: .init(rawValue: info.user.uid), accessToken: info.oauthCredentail.accessToken!)

        apollo.activate(with: me)

        self.me = me
    }
}


private func _githubCredential() async throws -> AuthCredential {
    let provider = OAuthProvider(providerID: "github.com")
    provider.customParameters = [
        "allow_signup": "false"
    ]

    return try await withCheckedThrowingContinuation { continuation in
        provider.getCredentialWith(nil) { credential, error in
            if let error = error {
                continuation.resume(throwing: error)
            } else {
                if let credential = credential {
                    continuation.resume(returning: credential)
                }
            }
        }
    }
}

private func _signIn(with credential: AuthCredential) async throws -> (oauthCredentail: OAuthCredential, user: FirebaseAuth.User) {
    return try await withCheckedThrowingContinuation { continuation in
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                continuation.resume(throwing: error)
            } else {
                guard let authResult = authResult, let oauthCredential = authResult.credential as? OAuthCredential else {
                    fatalError()
                }
                continuation.resume(returning: (oauthCredential, authResult.user))
            }
        }
    }
}
