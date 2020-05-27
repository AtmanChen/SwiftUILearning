// 

import Combine

class UserAuthorization: ObservableObject {
    
    let objectWillChange = ObservableObjectPublisher()
    
    var userName = "" {
        willSet {
            objectWillChange.send()
        }
    }
    
}
