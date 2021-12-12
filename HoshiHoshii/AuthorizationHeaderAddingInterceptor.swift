import Foundation
import Apollo
import FirebaseAuth

public class AuthorizationHeaderAddingInterceptor: ApolloInterceptor {
    let accessToken: String
    init(accessToken: String) {
        self.accessToken = accessToken
    }

    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            request.addHeader(name: "Authorization", value: "Bearer \(accessToken)")
            chain.proceedAsync(
                request: request,
                response: response,
                completion: completion
            )
        }
}


