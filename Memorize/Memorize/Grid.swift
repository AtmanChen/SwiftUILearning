//
//  Grid.swift
//  Memorize
//
//  Created by Anderson on 2020/5/30.
//  Copyright © 2020 d. All rights reserved.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
  var items: [Item]
  var viewForItem: (Item) -> ItemView
  
  init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
    self.items = items
    self.viewForItem = viewForItem
  }
  
  var body: some View {
    GeometryReader { geometry in
      self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
    }
  }
  
  private func body(for layout: GridLayout) -> some View {
    ForEach(items) { item in
      self.body(for: item, in: layout)
    }
  }
  
  private func body(for item: Item, in layout: GridLayout) -> some View {
    viewForItem(item)
      .frame(width: layout.itemSize.width, height: layout.size.height)
      .position(layout.location(ofItemAt: items.firstIndex(of: item)!))
  }
}

