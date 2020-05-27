// 

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var settings = UserAuthorization()
    
    private let prices = [123, 4, 56, 2020]
    
    var body: some View {
        VStack {
            ForEach(prices, id:\.self) { price in
                Group {
                    Text("$")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                    +
                    Text(self.priceAttributedString(with: price))
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func priceAttributedString(with price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "zh_Hans_CN")
        let numberString = numberFormatter.string(for: price)!
        return String(numberString.dropFirst())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
