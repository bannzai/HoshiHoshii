import Foundation
import Apollo
import ApolloSQLite

/// See also apollo-ios DefaultInterceptorProvider
///  https://github.com/apollographql/apollo-ios/blob/88ee167f247eedad81114da28311df17e8ad2afc/Sources/Apollo/DefaultInterceptorProvider.swift
public struct AppApolloInterceptorProvider: InterceptorProvider {
    private let store: ApolloStore
    private let client: URLSessionClient
    private let me: Me

    public init(store: ApolloStore, client: URLSessionClient, me: Me) {
        self.store = store
        self.client = client
        self.me = me
    }

    public func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            AuthorizationHeaderAddingInterceptor(accessToken: me.accessToken),
            RequestLoggingInterceptor(),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}

