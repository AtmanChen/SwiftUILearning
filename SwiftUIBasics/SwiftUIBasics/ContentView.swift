// 

import SwiftUI

struct Product: Identifiable {
  let title: String
  let id: Int
  let isFavorite: Bool
}

let products = (0...10).map { number in Product(title: "Anderson \(number)", id: number, isFavorite: number % 2 == 0) }

struct FilterView: View {
  @Binding var showFavorite: Bool
  var body: some View {
    Toggle(isOn: $showFavorite) {
      Text("Change filter")
    }
  }
}

struct ProductsView: View {
  let datasource = products
  @State private var showFavorited: Bool = false
  var body: some View {
    List {
      FilterView(showFavorite: $showFavorited)
      ForEach(datasource) { product in
        if !self.showFavorited || product.isFavorite {
          Text(product.title)
        }
      }
    }
  }
}

struct ContentView: View {
  
  @State var counter = 0
  
  var body: some View {
    //        ProductsView()
    ScrollableSelector(items: ["Menu 1", "Menu 2", "Menu 3",
                               "Menu 4", "Menu 5"])
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
