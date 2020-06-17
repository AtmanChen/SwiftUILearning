// 

import Foundation
import ComposableArchitecture
import Combine

final class GithubService {
  
  private let session: URLSession
  private let decoder: JSONDecoder
  
  private let decodeQueue = DispatchQueue(label: "com.github.decode", qos: .background, attributes: .concurrent)
  private let requestQueue = DispatchQueue(label: "com.github.request", qos: .default, attributes: .concurrent)
  
  init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
    self.session = session
    self.decoder = decoder
  }
  
  func search(matching query: String) -> Effect<[Repo], GithubSearchUserError> {
    guard query.count > 0 else {
      return Effect(value: [])
    }
    guard var urlComponents = URLComponents(string: "https://api.github.com/search/repositories") else {
        preconditionFailure("Can't create url components...")
    }
    urlComponents.queryItems = [
        URLQueryItem(name: "q", value: query)
    ]
    guard let url = urlComponents.url else {
        preconditionFailure("Can't create url from url components...")
    }
    print(url.absoluteString)
    return session
      .dataTaskPublisher(for: url)
      .receive(on: decodeQueue)
      .map { [weak self] (data, _) in
        let resp = try? self?.decoder.decode(SearchResponse.self, from: data)
        return resp?.items ?? []
      }
      .catch { _ in Just([]) }
      .mapError { _ in GithubSearchUserError() }
      .eraseToEffect()
  }
}
