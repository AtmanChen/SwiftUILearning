
import SwiftUI

struct ContentView: View {
    
    @State private var isButtonVisible = true
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.isButtonVisible.toggle()
                }
            }) {
                Text("Press me")
                    .foregroundColor(.white)
                    .frame(width: 120, height: 36)
                    .background(RoundedRectangle(cornerRadius: 18))
            }
            if isButtonVisible {
                Button(action: {}) {
                    Text("Hidden button")
                    .padding()
                }
                .animation(.easeInOut)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
