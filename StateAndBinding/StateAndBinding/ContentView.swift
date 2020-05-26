// 

import SwiftUI
import Knob

struct ContentView: View {
    
    @State var volume: Double = 0.5
    
    var body: some View {
        VStack {
            Knob(value: $volume)
                .frame(width: 100, height: 100)
            Slider(value: $volume, in: (0...1))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
