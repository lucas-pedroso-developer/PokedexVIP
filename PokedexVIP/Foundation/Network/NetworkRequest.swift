import Foundation

public protocol NetworkRequest {
    var baseUrl: String { get }
    var pathUrl: String { get }
    var method: HTTPMethod { get }
}

public enum HTTPMethod: String {
    case get
}

extension NetworkRequest {
    public var baseUrl: String {
        return "https://pokeapi.co/"
    }
    
    public var pathUrl: String  {
        return "api/v2/pokemon"
    }
}
