// 

import SwiftUI

private struct KnobShape: Shape {
  var pointerSize: CGFloat // these are relative values
  var pointerWidth: CGFloat = 0.1
  func path(in rect: CGRect) -> Path {
    let pointerHeight = rect.height * pointerSize
    let pointerWidth = rect.width * self.pointerWidth
    let circleRect = rect.insetBy(dx: pointerHeight, dy: pointerHeight)
    return Path { p in
      p.addEllipse(in: circleRect)
      p.addRect(CGRect(x: rect.midX - pointerWidth/2, y: 0, width: pointerWidth, height: pointerHeight + 2))
    }
  }
}

public struct Knob: View {
  var pointerSize: CGFloat?
  @Binding public var value: Double // should be between 0 and 1
  @Environment(\.colorScheme) public var colorScheme
  @Environment(\.knobPointerSize) public var envPointerSize
  @Environment(\.knobColor) public var knobColor
  
  public var body: some View {
    KnobShape(pointerSize: pointerSize ?? envPointerSize)
      .fill(knobColor ?? (colorScheme == .dark ? Color.white : Color.black))
      .rotationEffect(Angle(degrees: value * 330))
      .onTapGesture {
        withAnimation(.default) {
          self.value = self.value < 0.5 ? 1 : 0
        }
    }
  }
}

fileprivate struct PointerSizeKey: EnvironmentKey {
  static let defaultValue: CGFloat = 0.1
}

public extension EnvironmentValues {
  var knobPointerSize: CGFloat {
    set {
      self[PointerSizeKey.self] = newValue
    }
    get {
      self[PointerSizeKey.self]
    }
  }
}

public extension View {
  func knobPointerSize(_ size: CGFloat) -> some View {
    environment(\.knobPointerSize, size)
  }
}


public struct ColorKey: EnvironmentKey {
  static public let defaultValue: Color? = nil
}

public extension EnvironmentValues {
  var knobColor: Color? {
    set {
      self[ColorKey.self] = newValue
    }
    get {
      self[ColorKey.self]
    }
  }
}

public extension View {
  func knobColor(_ color: Color?) -> some View {
    environment(\.knobColor, color)
  }
}
