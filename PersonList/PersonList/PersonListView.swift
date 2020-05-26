// 

import SwiftUI

struct PersonListView: View {
    
    @ObservedObject var personStore = PersonStore()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(personStore.persons) { person in
                    PersonView(person: person)
                }
            }
            .navigationBarTitle("Persons")
        }
    }
}

struct PersonView: View {
    let person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.person.name)
                .font(.headline)
                .fontWeight(.semibold)
            Text(self.person.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
