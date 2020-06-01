// 

import SwiftUI
import Knob

struct ContentView: View {
  @State var volume: Double = 0.5
  @State var balance: Double = 0.5
  @State var customVolumeColor = false
  @State var customBalanceColor = false
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    HStack {
      VStack {
        Text("volume")
        Knob(value: $volume)
          .frame(width: 100, height: 100)
          .knobColor(customVolumeColor ? (Color(hue: volume, saturation: 0.5, brightness: 1.0)) : nil)
        Slider(value: $volume, in: (0...1))
        Toggle(isOn: $customVolumeColor) {
          Text("Custom Volum Color")
        }
      }
      VStack {
        Text("balance")
        Knob(value: $balance)
          .frame(width: 100, height: 100)
          .knobColor(customBalanceColor ? Color(hue: balance, saturation: 0.5, brightness: 1.0) : nil)
        Slider(value: $balance, in: (0...1))
        Toggle(isOn: $customBalanceColor) {
          Text("Custom Balance Color")
        }
      }
    }
    .padding()
    .knobPointerSize(0.1)
    //        MyNavigationView(content:
    //            Text("Environment")
    //                .padding()
    //                .myNavigationTitle("Root View")
    //                .background(Color.gray)
    //                .foregroundColor(.white)
    //        )
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

struct MyNavigationTitleKey: PreferenceKey {
  static var defaultValue: String?
  static func reduce(value: inout String?, nextValue: () -> String?) {
    value = value ?? nextValue()
  }
}

extension View {
  func myNavigationTitle(_ title: String) -> some View {
    preference(key: MyNavigationTitleKey.self, value: title)
  }
}


struct MyNavigationView<Content>: View where Content: View {
  let content: Content
  @State private var title: String?
  var body: some View {
    VStack {
      Text(title ?? "")
        .font(.largeTitle)
      content.onPreferenceChange(MyNavigationTitleKey.self) { title in
        self.title = title
      }
    }
  }
}


