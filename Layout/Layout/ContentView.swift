// 

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var isRunning: Bool = false
    @State var now: Date = Date()
//
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.now = Date()
        }
    }
    
    let image = Image(systemName: "ellipsis")
    
    var body: some View {
        
        MeasureBehavior(content:
            HStack {
                Text("Hello World!")
                Rectangle()
                    .fill(Color.red)
                    .frame(minWidth: 200)
            }
        )
        
        
        
//        Rectangle()
//            .rotation(.degrees(45))
//            .fill(Color.red)
//            .clipped()
//            .frame(width: 100, height: 100)
        
//        Circle()
//            .fill(Color.blue)
//            .overlay(Circle().strokeBorder(Color.white).padding(3))
//            .overlay(
//                Group {
//                    if self.isRunning {
//                        Text(countDownString(from: self.now, until: self.now.addingTimeInterval(10)))
//                            .foregroundColor(.white)
//                    } else {
//                        Text("Start")
//                            .foregroundColor(.white)
//                            .onTapGesture {
//                                self.isRunning = true
//                            }
//                    }
//                }
//            )
//            .frame(width: 75, height: 75)
        
//        HStack {
//            image
//                .frame(width: 100, height: 100)
//                .border(Color.red)
//            image.resizable()
//                .frame(width: 100, height: 100)
//                .border(Color.red)
//            image.resizable().aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
//                .border(Color.red)
//        }
        
//        Rectangle()
//            .rotation(.degrees(45))
//            .fill(Color.red)
//            .border(Color.blue)
//            .frame(width: 100, height: 100)
        
        
//        MeasureBehavior(content:
//            VStack {
//                Text("Hello, World!")
//                Path { p in
//                    p.move(to: CGPoint(x: 50, y: 0))
//                    p.addLines([
//                        CGPoint(x: 100, y: 75),
//                        CGPoint(x: 0, y: 75),
//                        CGPoint(x: 50, y: 0)
//                    ])
//                }
//            }
//        )
    }
    

    func countDownString(from date: Date, until nowDate: Date) -> String {
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar
                .dateComponents([.second]
                    ,from: nowDate,
                     to: date)
            return String(format: "%02ds",
                          components.second ?? 00)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
