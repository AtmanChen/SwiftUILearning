//
//  HackerNewsAPI.swift
//  HackerNewsAPI
//
//  Created by Anderson on 2020/5/30.
//  Copyright © 2020 com.Anderson. All rights reserved.
//

import Foundation
import Combine

public struct API {
  
  public init() {}
  /// API Errors.
  public enum Error: LocalizedError {
    case addressUnreachable(URL)
    case invalidResponse
    
    public var errorDescription: String? {
      switch self {
      case .invalidResponse: return "The server responded with garbage."
      case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
      }
    }
  }
  
  /// API endpoints.
  public enum EndPoint {
    static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
    
    case stories
    case story(Int)
    
    var url: URL {
      switch self {
      case .stories:
        return EndPoint.baseURL.appendingPathComponent("newstories.json")
      case .story(let id):
        return EndPoint.baseURL.appendingPathComponent("item/\(id).json")
      }
    }
  }
  
  /// Maximum number of stories to fetch (reduce for lower API strain during development).
  var maxStories = 10
  
  /// A shared JSON decoder to use in calls.
  private let decoder = JSONDecoder()
  
  //
  func story(with id: Int) -> AnyPublisher<Story, Error> {
    URLSession.shared
      .dataTaskPublisher(for: EndPoint.story(id).url)
      .receive(on: apiQueue)
      .map(\.data)
      .decode(type: Story.self, decoder: decoder)
      .catch { _ in Empty().eraseToAnyPublisher() }
      .eraseToAnyPublisher()
  }
  
  func mergedStories(for storyIDs: [Int]) -> AnyPublisher<Story, Error> {
    let storyIDs = Array(storyIDs.prefix(maxStories))
    
    precondition(!storyIDs.isEmpty)
    
    let initialPublisher = story(with: storyIDs[0])
    let reminder = Array(storyIDs.dropFirst())
    
    return reminder.reduce(initialPublisher) { acc, id in
      return acc
        .merge(with: story(with: id))
        .eraseToAnyPublisher()
    }
  }
  
  public func stories() -> AnyPublisher<[Story], Error> {
    URLSession.shared
      .dataTaskPublisher(for: EndPoint.stories.url)
      .receive(on: apiQueue)
      .map(\.data)
      .decode(type: [Int].self, decoder: decoder)
      .mapError { error -> API.Error in
        switch error {
        case is URLError:
          return Error.addressUnreachable(EndPoint.stories.url)
        default:
          return Error.invalidResponse
        }
      }
      .filter { !$0.isEmpty }
      .flatMap { storyIDs in
        self.mergedStories(for: storyIDs)
      }
      .scan([]) { stories, story -> [Story] in
        stories + [story]
      }
      .map { $0.sorted() }
      .eraseToAnyPublisher()
  }
  
  private let apiQueue = DispatchQueue(label: "API",
                                       qos: .default,
                                       attributes: .concurrent)
  
}
