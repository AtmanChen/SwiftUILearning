// 

import SwiftUI

struct Constants {
  static let minHeightRatio: CGFloat = 0.3
  static let indicatorRadius: CGFloat = 4
  static let indicatorWidth: CGFloat = 60
  static let indicatorHeight: CGFloat = 8
  static let sheetRadius: CGFloat = 10
  static let snapRatio: CGFloat = 0.5
}

struct BottomSheetView<Content: View>: View {
  
  @Binding var isOpen: Bool
  @GestureState private var translation: CGFloat = 0
  
  let maxHeight: CGFloat
  let minHeight: CGFloat
  let content: Content
  
  private var offset: CGFloat {
    isOpen ? 0 : maxHeight - minHeight
  }
  
  private var indicator: some View {
    RoundedRectangle(cornerRadius: Constants.indicatorRadius)
      .fill(Color.secondary)
      .frame(width: Constants.indicatorWidth, height: Constants.indicatorHeight)
  }
  
  init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
    self._isOpen = isOpen
    self.maxHeight = maxHeight
    self.minHeight = maxHeight * Constants.minHeightRatio
    self.content = content()
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        self.indicator.padding()
        self.content
      }
      .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
      .background(Color(.secondarySystemBackground))
      .cornerRadius(Constants.sheetRadius)
      .frame(height: geometry.size.height, alignment: .bottom)
      .offset(y: max(self.offset + self.translation, 0))
      .animation(.interactiveSpring())
      .gesture(
        DragGesture().updating(self.$translation) { value, state, _ in
          state = value.translation.height
        }.onEnded { value in
          let snapDistance = self.maxHeight * Constants.snapRatio
          guard abs(value.translation.height) > snapDistance else {
            return
          }
          self.isOpen = value.translation.height < 0
        }
      )
    }
  }
}

//struct BottomSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheetView()
//    }
//}
