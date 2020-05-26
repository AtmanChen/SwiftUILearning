// 

import SwiftUI

struct EditingView: View {
    @Environment(\.presentationMode) var presentation
    @Binding var person: Person
    
    init(person: Binding<Person>) {
        self._person = person
    }
    
    var body: some View {
        Form {
            Section(header: Text("Person Information")) {
                TextField("...typing something", text: $person.name)
                Stepper(value: $person.age) {
                    Text("Age: \(person.age)")
                }
            }
            Section {
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        }
    }
}

struct EditingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView(person: .constant(Person(name: "Good", age: 33, description: "Developer")))
    }
}
