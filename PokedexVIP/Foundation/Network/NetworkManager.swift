import Foundation

public typealias NetworkResult<T: Decodable> = ((Result<T, Error>) -> Void)

public protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ request: NetworkRequest, completion: @escaping NetworkResult<[T]>)
}

public final class NetworkManager: NetworkManagerProtocol {
    private let urlSession: URLSessionProtocol
    
    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func request<T>(_ request: NetworkRequest, completion: @escaping NetworkResult<[T]>) {
        guard let url = URL(string: request.baseUrl + request.pathUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = NSMutableURLRequest(url: url) as URLRequest
        urlRequest.httpMethod = request.method.rawValue.uppercased()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlSession.loadData(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode([T].self, from: data)
                completion(.success(result))
                
            } catch {
                completion(.failure(NetworkError.decodeError))
            }
        }
    }
}
