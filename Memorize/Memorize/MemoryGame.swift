
import Foundation

struct MemoryGame<CardContent> {
    
    var cards: [Card]
    
    mutating func choose(card: Card) {
        let cardIndex = cards.firstIndex { $0.id == card.id }
        guard let index = cardIndex else {
            return
        }
        var newCard = card
        newCard.isFaceUp = !card.isFaceUp
        cards[index] = newCard
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
