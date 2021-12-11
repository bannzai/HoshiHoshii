import Foundation
import Apollo

public class AuthorizationHeaderAddingInterceptor: ApolloInterceptor {
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            request.addHeader(name: "Authorization", value: "Bearer \(AccessToken.accessToken!)")

            chain.proceedAsync(
                request: request,
                response: response,
                completion: completion
            )
        }
}

