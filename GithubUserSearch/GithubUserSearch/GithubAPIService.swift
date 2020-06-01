// 

import Foundation
import Combine

struct SearchUserResponse: Decodable {
  var items: [GithubUser]
}

struct GithubUser: Hashable, Identifiable, Decodable {
  var id: Int64
  var login: String
  var avatar_url: URL
}

enum RequestError: Error {
    case request(code: Int, error: Error?)
    case unknown
}

struct GithubAPIService {
  static let shared = GithubAPIService()
  private let apiQueue = DispatchQueue(label: "github.api.queue", qos: .default, attributes: .concurrent)
  private init() {}
  
  func search(username: String) -> AnyPublisher<[GithubUser], RequestError> {
    var urlComponents = URLComponents(string: "https://api.github.com/search/users")!
    urlComponents.queryItems = [URLQueryItem(name: "q", value: username)]
    var request = URLRequest(url: urlComponents.url!)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    return URLSession.shared
      .dataTaskPublisher(for: request)
      .receive(on: self.apiQueue)
      .map(\.data)
      .decode(type: SearchUserResponse.self, decoder: JSONDecoder())
      .mapError { error -> RequestError in
        return .unknown
      }
      .map(\.items)
      .eraseToAnyPublisher()
  }
}
