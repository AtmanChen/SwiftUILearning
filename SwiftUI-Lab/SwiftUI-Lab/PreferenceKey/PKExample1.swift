
import SwiftUI

struct PKExample1: View {
  @State private var activeIdx: Int = 0
  var body: some View {
    VStack {
      Spacer()
      HStack {
        MonthView(activeMonth: $activeIdx, label: "January", idx: 0)
        MonthView(activeMonth: $activeIdx, label: "February", idx: 1)
        MonthView(activeMonth: $activeIdx, label: "March", idx: 2)
        MonthView(activeMonth: $activeIdx, label: "April", idx: 3)
      }
      Spacer()
      HStack {
        MonthView(activeMonth: $activeIdx, label: "May", idx: 4)
        MonthView(activeMonth: $activeIdx, label: "June", idx: 5)
        MonthView(activeMonth: $activeIdx, label: "July", idx: 6)
        MonthView(activeMonth: $activeIdx, label: "August", idx: 7)
      }
      Spacer()
      HStack {
        MonthView(activeMonth: $activeIdx, label: "September", idx: 8)
        MonthView(activeMonth: $activeIdx, label: "October", idx: 9)
        MonthView(activeMonth: $activeIdx, label: "November", idx: 10)
        MonthView(activeMonth: $activeIdx, label: "December", idx: 11)
      }
    }
    .navigationBarTitle("PreferenceKey Example One")
  }
}

struct MonthView: View {
  @Binding var activeMonth: Int
  let label: String
  let idx: Int
  var body: some View {
    Text(label)
      .padding()
      .onTapGesture { self.activeMonth = self.idx }
      .background(MonthBorder(show: activeMonth == idx))
  }
}

struct MonthBorder: View {
  let show: Bool
  var body: some View {
    RoundedRectangle(cornerRadius: 15)
      .stroke(lineWidth: 3)
      .foregroundColor(show ? .red : .clear)
      .animation(.easeInOut(duration: 0.3))
  }
}

struct MyTextPreferenceData: Equatable {
  let viewIdx: Int
  let rect: CGRect
}

struct MyTextPreferenceKey: PreferenceKey {
  static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
    value.append(contentsOf: nextValue())
  }
  
  typealias Value = [MyTextPreferenceData]
  static var defaultValue: [MyTextPreferenceData] = []
  
}
