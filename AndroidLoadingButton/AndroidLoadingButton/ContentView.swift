// 

import SwiftUI

enum AndroidLoadingButtonState {
  case normal
  case loading
}

struct ContentView: View {
  
  @State var buttonState: AndroidLoadingButtonState = .normal
  
  private var isButtonNormal: Bool { buttonState == .normal }
  private var buttonTitle: String { isButtonNormal ? "Log In" : "" }
  private var buttonWidth: CGFloat { isButtonNormal ? 120 : 36 }
  private var buttonDisabled: Bool { !isButtonNormal }
  
  var body: some View {
    Button(action: {
      if self.buttonState == .normal {
        self.buttonState = .loading
      }
    }) {
      Text(buttonTitle)
        .frame(width: buttonWidth, height: 36)
        .background(Color.black)
        .foregroundColor(.white)
        .animation(.default)
    }
    .disabled(buttonDisabled)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
