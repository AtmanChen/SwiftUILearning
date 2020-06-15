// 

import SwiftUI

extension View {
  func badge(count: Int, bg: Color = .red) -> some View {
    overlay(
      ZStack {
        if count != 0 {
          Circle()
            .fill(bg)
          Text("\(count)")
            .foregroundColor(.white)
            .font(.caption)
        }
      }
      .offset(CGSize(width: 12, height: -12))
      .frame(width: 24, height: 24)
    , alignment: .topTrailing)
  }
}
