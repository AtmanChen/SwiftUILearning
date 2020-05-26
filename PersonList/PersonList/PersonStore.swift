// 

import Foundation

struct Person: Identifiable {
    let id: UUID = UUID()
    var name: String
    var age: Int
    let description: String
}

final class PersonStore: ObservableObject {
    
    @Published var persons: [Person] = [
        Person(name: "Foo", age: 29, description: "React Developer"),
        Person(name: "Bar", age: 30, description: "Haskell"),
        Person(name: "Anderson", age: 32, description: "iOS Developer"),
    ]
    
}
