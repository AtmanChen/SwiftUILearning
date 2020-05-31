// 

import SwiftUI

struct EmojiCardGameView: View {
  
  @ObservedObject var viewModel: EmojiMemoryGame
  
  var body: some View {
    Grid(viewModel.cards) { card in
      CardView(card: card).onTapGesture { self.viewModel.choose(card: card) }
      .padding()
    }
    .padding()
    .foregroundColor(.orange)
  }
}

struct CardView: View {
  var card: MemoryGame<String>.Card
  var body: some View {
    GeometryReader { geometry in
      self.body(for: geometry.size)
    }
  }
  
  private func body(for size: CGSize) -> some View {
    ZStack {
      if card.isFaceUp {
        RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
        RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
        Text(card.cardContent)
      } else {
        RoundedRectangle(cornerRadius: cornerRadius).fill()
      }
    }
    .aspectRatio(2 / 3 , contentMode: .fit)
    .font(Font.system(size: font(for: size)))
  }
  
  private let cornerRadius: CGFloat = 10
  private let edgeLineWidth: CGFloat = 3
  private func font(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * 0.75
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    EmojiCardGameView(viewModel: EmojiMemoryGame())
  }
}
