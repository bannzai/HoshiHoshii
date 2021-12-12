import Foundation
import Apollo
import FirebaseAuth

public class AuthorizationHeaderAddingInterceptor: ApolloInterceptor {
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            guard let currentUser = Auth.auth().currentUser else {
                return
            }

            currentUser.getIDToken(completion: { idToken, error in
                if let error = error {
                    if case .networkError = AuthErrorCode(rawValue: error._code) {
                        chain.retry(request: request, completion: completion)
                    } else {
                        chain.handleErrorAsync(error, request: request, response: response, completion: completion)
                    }
                } else if let idToken = idToken {
                    request.addHeader(name: "Authorization", value: "Bearer \(idToken)")

                    chain.proceedAsync(
                        request: request,
                        response: response,
                        completion: completion
                    )
                } else {
                    fatalError("unexpected error and idToken are nil")
                }
            })
        }
}


