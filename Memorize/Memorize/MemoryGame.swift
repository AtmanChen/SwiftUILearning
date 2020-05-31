
import Foundation

struct MemoryGame<CardContent> {
  
  var cards: [Card]
  
  mutating func choose(card: Card) {
    guard let chosenIndex = self.cards.firstIndex(of: card) else {
      return
    }
    self.cards[chosenIndex].isFaceUp.toggle()
  }
  
  init(numbersOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
    cards = (0..<numbersOfPairsOfCards).map { index in
      let card = Card(cardContent: cardContentFactory(index), id: index + 1)
      return card
    }
  }
  
  struct Card: Identifiable {
    var isFaceUp: Bool = true
    var isMatched: Bool = false
    var cardContent: CardContent
    let id: Int
  }
}
