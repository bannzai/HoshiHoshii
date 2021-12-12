import Foundation
import Apollo
import ApolloSQLite
import SwiftUI

public final class AppApolloClient {
    fileprivate init() { }

    private let store: ApolloStore = {
        let documentsURL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        let cache = try! SQLiteNormalizedCache(fileURL: documentsURL.appendingPathComponent("apollo_db.sqlite"))
        return .init(cache: cache)
    }()

    private var headers: [String: String] {
        [:]
    }

    internal var apollo: Apollo.ApolloClient!

    func activate(with me: Me) {
        let interceptorProvider = AppApolloInterceptorProvider(store: store, client: .init(sessionConfiguration: .default, callbackQueue: .main), me: me)

        let endpointURL = URL(string: "https://api.github.com/graphql")!
        let networkTransport = RequestChainNetworkTransport(
            interceptorProvider: interceptorProvider,
            endpointURL: endpointURL,
            additionalHeaders: headers
        )
        let apollo = Apollo.ApolloClient(networkTransport: networkTransport, store: store)
        apollo.cacheKeyForObject = { $0["id"] }
        self.apollo = apollo
    }
}

// MARK: - Error
extension AppApolloClient {
    // Named error for Posusume app
    public struct AppGraphQLError: Error {
        // Application error caused by server side application
        public let applicationErrors: [Apollo.GraphQLError]

        internal init(_ errors: [Apollo.GraphQLError]) {
            self.applicationErrors = errors
        }
    }
}

// MARK: - async/await
extension AppApolloClient {
    func fetchFromCache<Query: GraphQLQuery>(query: Query) async throws -> Query.Data? {
        try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query, cachePolicy: .returnCacheDataDontFetch) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.resume(with: .failure(AppGraphQLError(errors)))
                    } else {
                        // NOTE: Occurs when the Local Cache does not hit
                        continuation.resume(returning: nil)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchFromServer<Query: GraphQLQuery>(query: Query) async throws -> Query.Data {
        try await withCheckedThrowingContinuation { continuation in
            apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.resume(with: .failure(AppGraphQLError(errors)))
                    } else {
                        fatalError("Unexpected result.data and result.errors not found. Maybe apollo-ios or server side application bug")
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func perform<Mutation: GraphQLMutation>(mutation: Mutation) async throws -> Mutation.Data {
        try await withCheckedThrowingContinuation { continuation in
            apollo.perform(mutation: mutation) { result in
                do {
                    let response = try result.get()
                    if let data = response.data {
                        continuation.resume(returning: data)
                    } else if let errors = response.errors, !errors.isEmpty {
                        continuation.resume(with: .failure(AppGraphQLError(errors)))
                    } else {
                        fatalError("Unexpected result.data and result.errors not found. Maybe apollo-ios or server side application bug")
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    actor WatchCanceller {
        var canceller: Apollo.Cancellable?

        func setCanceller(_ canceller: Apollo.Cancellable) {
            self.canceller = canceller
        }
        func cancel() {
            canceller?.cancel()
        }
    }
    func watch<Query: GraphQLQuery>(query: Query) -> AsyncThrowingStream<Query.Data, Error> {
        AsyncThrowingStream { continuation in
            Task {
                let canceller = WatchCanceller()
                continuation.onTermination = { @Sendable _ in
                    Task {
                        await canceller.cancel()
                    }
                }

                let apolloCanceller = apollo.watch(query: query) { result in
                    do {
                        let response = try result.get()
                        if let data = response.data {
                            continuation.yield(data)
                        } else if let errors = response.errors, !errors.isEmpty {
                            continuation.finish(throwing: AppGraphQLError(errors))
                        } else {
                            fatalError("Unexpected result.data and result.errors not found. Maybe apollo-ios or server side application bug")
                        }
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }

                await canceller.setCanceller(apolloCanceller)
            }
        }
    }
}

public struct AppApolloClientEnvironmentKey: EnvironmentKey {
    public static var defaultValue: AppApolloClient = .init()
}

public extension EnvironmentValues {
    var apollo: AppApolloClient {
        get {
            self[AppApolloClientEnvironmentKey.self]
        }
        set {
            self[AppApolloClientEnvironmentKey.self] = newValue
        }
    }
}

