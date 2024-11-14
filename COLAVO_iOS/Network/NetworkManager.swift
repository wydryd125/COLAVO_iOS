//
//  NetworkManager.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import Foundation
import Combine

enum API {}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case network
    case decoding
}

final class NetworkManager {
    public static let instance = NetworkManager()
    private let session: URLSession
    private let apiUrl = "https://us-central1-colavolab.cloudfunctions.net"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    enum Encoding {
        case json
        case url
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> AnyPublisher<Response, NetworkError> {
        let encoding: Encoding
        switch endpoint.method {
        case .post, .put, .patch:
            encoding = .json
        default:
            encoding = .url
        }
        
        guard var urlComponents = URLComponents(string: apiUrl + endpoint.path.stringValue) else {
            return Fail(error: NetworkError.network).eraseToAnyPublisher()
        }
        
        guard let url = urlComponents.url else {
            return Fail(error: NetworkError.network).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }
        
        if let parameters = endpoint.parameters, encoding == .json {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return session.fetchData(request: request)
            .tryMap { data in
                do {
                    return try endpoint.decode(data)
                } catch {
                    throw NetworkError.decoding
                }
            }
            .mapError { error in
                (error as? NetworkError) ?? .network
            }
            .eraseToAnyPublisher()
    }
}

extension URLSession {
    func fetchData(request: URLRequest) -> AnyPublisher<Data, Error> {
        return self.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw NetworkError.network
                }
                return result.data
            }
            .eraseToAnyPublisher()
    }
}

