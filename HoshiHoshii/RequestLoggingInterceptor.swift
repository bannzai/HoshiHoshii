import Foundation
import Apollo

public struct RequestLoggingInterceptor: ApolloInterceptor {
    public func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        print(
            "========= Begin \(request.operation.operationName) =========",
            "\(request)",
            "========= End \(request.operation.operationName) =========",
            separator: "\n"
        )
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}
