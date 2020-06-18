// 

import SwiftUI

struct RootView: View {
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Preference Key Examples")) {
          NavigationLink(
            "PreferenceKey Example One",
            destination: PKExample1()
          )
        }
      }
      .navigationBarTitle("SwiftUI-Lab")
    }
  }
}


