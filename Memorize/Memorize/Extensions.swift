//
//  Extensions.swift
//  Memorize
//
//  Created by Anderson on 2020/5/30.
//  Copyright © 2020 d. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
  func firstIndex(of element: Element) -> Int? {
    for index in 0..<self.count {
      if self[index].id == element.id {
        return index
      }
    }
    return nil
  }
}
