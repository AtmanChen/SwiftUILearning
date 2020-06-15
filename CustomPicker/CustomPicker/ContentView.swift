// 

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Int = 0
    private let items: [String] = ["M", "T", "W", "T", "F", "M", "T", "W", "T", "F"]
    
    var body: some View {
        SegmentedPicker(items: items, selection: $selection)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
