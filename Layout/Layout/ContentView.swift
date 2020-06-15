// 

import SwiftUI
import Combine

struct ContentView: View {
  @State var expanded: Bool = true
  @State var isRunning: Bool = false
  @State var now: Date = Date()
  //
  var timer: Timer {
    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.now = Date()
    }
  }
  
  let image = Image(systemName: "ellipsis")
  
  let colors: [(Color, CGFloat)] = [(.init(white: 0.3), 50), (.init(white: 0.8), 30), (.init(white: 0.5), 75)]
  
  var body: some View {
    VStack {
      Collapsible(
        data: colors,
        expanded: expanded,
        content: { (item: (Color, CGFloat)) in
          Rectangle()
            .fill(item.0)
            .frame(width: item.1, height: item.1)
        })
      Button(expanded ? "Collapse" : "Expand") {
        self.expanded.toggle()
      }
      .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
      .background(Color.blue)
      .foregroundColor(.white)
//      .clipShape(Capsule())
      .badge(count: 5)
    }
  }
  
  
  func countDownString(from date: Date, until nowDate: Date) -> String {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar
      .dateComponents([.second]
        ,from: nowDate,
         to: date)
    return String(format: "%02ds",
                  components.second ?? 00)
  }
}

struct Collapsible<Element, Content: View>: View {
  var data: [Element]
  var expanded: Bool
  var content: (Element) -> Content
  var alignment: VerticalAlignment = .center
  var body: some View {
    HStack {
      ForEach(data.indices, content: { self.child(at: $0) })
    }
  }
  private func child(at index: Int) -> some View {
    content(data[index])
      .frame(
        width: expanded ? nil : 10,
        alignment: Alignment(
          horizontal: .leading,
          vertical: alignment
        )
      )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
