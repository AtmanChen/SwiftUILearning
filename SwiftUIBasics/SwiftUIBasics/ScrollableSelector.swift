// 

import SwiftUI

struct ScrollableSelector: View {
  
  let items: [String]
  @State var selectIndex: Int = 0
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(alignment: .center, spacing: 12) {
        ForEach(items.indices) { index in
          self.text(at: index)
        }
      }
      .padding([.leading, .trailing], 4)
    }
    .frame(height: 36)
    .background(Color.gray.opacity(0.4))
    .cornerRadius(8)
  }
  
  private func text(at index: Int) -> some View {
    Group {
      if index == self.selectIndex {
        Text(items[index])
          .font(.headline)
          .fontWeight(.heavy)
          .foregroundColor(.white)
          .padding(4)
          .background(Color.black)
          .cornerRadius(8)
      } else {
        Text(items[index])
          .foregroundColor(.black)
          .font(.headline)
          .onTapGesture {
            self.selectIndex = index
          }
      }
    }
  }
  
}

struct ScrollableSelector_Previews: PreviewProvider {
  static var previews: some View {
    ScrollableSelector(items: ["Menu 1", "Menu 2", "Menu 3",
    "Menu 4", "Menu 5", "Menu 6",
    "Menu 7", "Menu 8"])
  }
}
