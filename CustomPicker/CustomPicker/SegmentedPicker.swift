// 

import SwiftUI

struct SizeReferenceKey: PreferenceKey {
  typealias Value = CGSize
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> Value) {
    value = nextValue()
  }
}

struct BackgroundGeometryReader: View {
  var body: some View {
    GeometryReader { geometry in
      Color
        .clear
        .preference(key: SizeReferenceKey.self, value: geometry.size)
    }
  }
}

struct SizeAwareViewModifier: ViewModifier {
  @Binding private var viewSize: CGSize
  
  init(viewSize: Binding<CGSize>) {
    self._viewSize = viewSize
  }
  
  func body(content: Content) -> some View {
    content
      .background(BackgroundGeometryReader())
      .onPreferenceChange(SizeReferenceKey.self) { size in
        if self.viewSize != size {
          self.viewSize = size
        }
    }
  }
}

struct SegmentedPicker: View {
  
  private static let activeSegmentColor = Color(.tertiarySystemBackground)
  private static let backgroundColor = Color(.secondarySystemBackground)
  private static let shadowColor = Color.black.opacity(0.2)
  private static let plainTextColor = Color(.secondaryLabel)
  private static let selectedTextColor = Color(.label)
  private static let textFont = Font.system(size: 12)
  private static let segmentCornerRadius: CGFloat = 12
  private static let shadowRadius: CGFloat = 4
  private static let segmentXPadding: CGFloat = 16
  private static let segmentYPadding: CGFloat = 8
  private static let pickerPadding: CGFloat = 4
  private static let animationDuration: TimeInterval = 0.1
  
  @Binding private var selection: Int
  @State private var segmentSize: CGSize = .zero
  private let items: [String]
  
  private var activeSegmentView: some View {
    RoundedRectangle(cornerRadius: SegmentedPicker.segmentCornerRadius)
      .foregroundColor(SegmentedPicker.activeSegmentColor)
      .shadow(color: SegmentedPicker.shadowColor, radius: SegmentedPicker.shadowRadius)
      .frame(width: self.segmentSize.width, height: self.segmentSize.height)
      .offset(x: activeSegmentViewOffset(), y: 0)
      .animation(.spring())
  }
  
  init(items: [String], selection: Binding<Int>) {
    self.items = items
    self._selection = selection
  }
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ZStack(alignment: .leading) {
        activeSegmentView
        HStack {
          ForEach(0..<items.count, id: \.self) { index in
            self.getSegmentView(at: index)
          }
        }
      }
      .padding(SegmentedPicker.pickerPadding)
      .background(SegmentedPicker.backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: SegmentedPicker.segmentCornerRadius))
    }
  }
  
  private func getSegmentView(at index: Int) -> some View {
    let isSelected = index == self.selection
    return
      Text(items[index])
        .foregroundColor(isSelected ? SegmentedPicker.selectedTextColor : SegmentedPicker.plainTextColor)
        .lineLimit(1)
        .padding(.vertical, SegmentedPicker.segmentYPadding)
        .padding(.horizontal, SegmentedPicker.segmentXPadding)
        .frame(minWidth: 0, maxWidth: .infinity)
        .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
        .onTapGesture {
          self.selection = index
    }
  }
  
  private func activeSegmentViewOffset() -> CGFloat {
    CGFloat(self.selection) * (self.segmentSize.width + SegmentedPicker.segmentXPadding / 2)
  }
}

struct SegmentedPicker_Previews: PreviewProvider {
  static var previews: some View {
    SegmentedPicker(items: [], selection: .constant(0))
  }
}
