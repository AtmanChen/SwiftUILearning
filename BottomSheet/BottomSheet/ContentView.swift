// 

import SwiftUI

struct ContentView: View {
    
    @State var bottomSheetShown = false
    
    var body: some View {
        GeometryReader { geometry in
            Color.black
            BottomSheetView(
                isOpen: self.$bottomSheetShown,
                maxHeight: geometry.size.height * 0.7) {
                    Color.red.opacity(0.8)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
