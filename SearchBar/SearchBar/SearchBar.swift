// 

import SwiftUI

public struct SearchBar: UIViewRepresentable {
  @Binding public var text: String
  public var placeHolder: String
  public init(text: Binding<String>, placeHolder: String) {
    self._text = text
    self.placeHolder = placeHolder
  }
  public func makeCoordinator() -> Coordinator {
    Coordinator($text)
  }
  
  public func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
    let searchBar = UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    searchBar.placeholder = placeHolder
    searchBar.searchBarStyle = .minimal
    searchBar.autocapitalizationType = .none
    return searchBar
  }
  
  public func updateUIView(_ uiView: UISearchBar, context: Context) {
    uiView.text = text
  }
}

public class Coordinator: NSObject, UISearchBarDelegate {
  @Binding var text: String
  init(_ text: Binding<String>) {
    self._text = text
  }
  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    text = searchText
  }
}

