//
//  Story.swift
//  HackerNewsAPI
//
//  Created by Anderson on 2020/5/30.
//  Copyright © 2020 com.Anderson. All rights reserved.
//

import Foundation

public struct Story: Codable {
  public let id: Int
  public let title: String
  public let by: String
  public let time: TimeInterval
  public let url: String
}

extension Story: Comparable {
  public static func < (lhs: Story, rhs: Story) -> Bool {
    return lhs.time > rhs.time
  }
}

extension Story: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "\n\(title)\nby \(by)\n\(url)\n-----"
  }
}
