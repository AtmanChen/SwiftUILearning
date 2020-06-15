// 

import SwiftUI
import ComposableArchitecture

private let readMe = """
This screen demonstrates how multiple independent screens can share state in the Composable \
Architecture. Each tab manages its own state, and could be in separate modules, but changes in \
one tab are immediately reflected in the other.

This tab has its own state, consisting of a count value that can be incremented and decremented, \
as well as an alert value that is set when asking if the current count is prime.

Internally, it is also keeping track of various stats, such as min and max counts and total \
number of count events that occurred. Those states are viewable in the other tab, and the stats \
can be reset from the other tab.
"""

struct SharedState: Equatable {
  enum Tab {
    case counter, profile
  }
  struct CounterState: Equatable {
    var alert: String?
    var count: Int = 0
    var maxCount: Int = 0
    var minCount: Int = 0
    var numberOfCount: Int = 0
  }
  struct ProfileState: Equatable {
    private(set) var currentTab: Tab
    private(set) var count: Int = 0
    private(set) var minCount: Int
    private(set) var maxCount: Int
    private(set) var numberOfCount: Int
    
    fileprivate mutating func resetCount() {
      self.currentTab = .counter
      self.count = 0
      self.minCount = 0
      self.maxCount = 0
      self.numberOfCount = 0
    }
  }
  
  var counter = CounterState()
  var currentTab: Tab = .counter
  var profileState: ProfileState {
    get {
      ProfileState(
        currentTab: self.currentTab,
        count: self.counter.count,
        minCount: self.counter.minCount,
        maxCount: self.counter.maxCount,
        numberOfCount: self.counter.numberOfCount)
    }
    set {
      self.currentTab = newValue.currentTab
      self.counter.count = newValue.count
      self.counter.minCount = newValue.minCount
      self.counter.maxCount = newValue.maxCount
      self.counter.numberOfCount = newValue.numberOfCount
    }
  }
}

enum SharedStateAction {
  enum CounterAction {
    case alertDismissed
    case decrementButtonTapped
    case incrementButtonTapped
    case isPrimeButtonTapped
  }
  enum ProfileAction {
    case resetCounterButtonTapped
  }
  
  case counter(CounterAction)
  case profile(ProfileAction)
  case selectTab(SharedState.Tab)
}

let counterStateReducer = Reducer<
  SharedState.CounterState, SharedStateAction.CounterAction, Void
  > { state, action, _ in
    switch action {
    case .alertDismissed:
      state.alert = nil
      return .none
    case .decrementButtonTapped:
      state.count -= 1
      state.numberOfCount += 1
      state.minCount = min(state.count, state.minCount)
      return .none
    case .incrementButtonTapped:
      state.count += 1
      state.numberOfCount += 1
      state.maxCount = max(state.count, state.maxCount)
      return .none
    case .isPrimeButtonTapped:
      state.alert =
        isPrime(state.count)
        ? "👍 The number \(state.count) is prime!"
        : "👎 The number \(state.count) is not prime :("
      return .none
    }
}

let profileStateReducer = Reducer<
  SharedState.ProfileState, SharedStateAction.ProfileAction, Void
  > { state, action, _ in
    switch action {
    case .resetCounterButtonTapped:
      state.resetCount()
      return .none
    }
}

let sharedStateReducer: Reducer<SharedState, SharedStateAction, Void> = .combine(
  Reducer { state, action, _ in
    switch action {
    case .counter, .profile:
      return .none
    case let .selectTab(tab):
      state.currentTab = tab
      return .none
    }
  },
  counterStateReducer.pullback(
    state: \.counter,
    action: /SharedStateAction.counter,
    environment: { _ in () }
  ),
  profileStateReducer.pullback(
    state: \.profileState,
    action: /SharedStateAction.profile,
    environment: { _ in () }
  )
)

struct ContentView: View {
  let store: Store<SharedState, SharedStateAction>
  var body: some View {
    WithViewStore(self.store.scope(state: \.currentTab)) { viewStore in
      NavigationView {
        VStack {
          Picker(
            "Tab",
            selection: viewStore.binding(send: SharedStateAction.selectTab)) {
              Text("Counter")
                .tag(SharedState.Tab.counter)
              Text("Profile")
                .tag(SharedState.Tab.profile)
          }
          .pickerStyle(SegmentedPickerStyle())
          
          if viewStore.state == .counter {
            SharedStateCounterView(
              store: self.store.scope(state: \.counter, action: SharedStateAction.counter)
            )
          }
          if viewStore.state == .profile {
            SharedStateProfileView(
              store: self.store.scope(state: \.profileState, action: SharedStateAction.profile))
          }
          Spacer()
        }
        .padding()
      }
    }
  }
}

struct SharedStateCounterView: View {
  let store: Store<SharedState.CounterState, SharedStateAction.CounterAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 64) {
        Text(readMe)
          .foregroundColor(.secondary)
          .font(.caption)
        
        VStack(spacing: 16) {
          HStack {
            Button("-") { viewStore.send(.decrementButtonTapped) }
            Text("\(viewStore.count)")
              .foregroundColor(.primary)
              .font(Font.body.monospacedDigit())
            Button("+") { viewStore.send(.incrementButtonTapped) }
          }
          Button("Is this Prime") {
            viewStore.send(.isPrimeButtonTapped)
          }
        }
      }
      .padding(16)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
      .navigationBarTitle("Shared State Demo")
      .alert(
        item: viewStore.binding(
          get: { $0.alert.map(PrimeAlert.init(title:)) },
          send: .alertDismissed
        )
      ) { alert in
        SwiftUI.Alert(title: Text(alert.title))
      }
    }
  }
}

struct SharedStateProfileView: View {
  let store: Store<SharedState.ProfileState, SharedStateAction.ProfileAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 64) {
        Text("""
            This tab shows state from the previous tab, and it is capable of reseting all of the \
            state back to 0.

            This shows that it is possible to for each screen to model its state in the way that \
            makes the most sense for it, while still allowing the state and mutations to be shared \
            across independent screens.
            """
        ).font(.caption)
        
        VStack(spacing: 16) {
          Text("Current count: \(viewStore.count)")
          Text("Max count: \(viewStore.maxCount)")
          Text("Min count: \(viewStore.minCount)")
          Text("Total number of count: \(viewStore.numberOfCount)")
        }
      }
      .padding(16)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
      .navigationBarTitle("Profile")
    }
  }
}

private struct PrimeAlert: Equatable, Identifiable {
  let title: String
  var id: String { self.title }
}

private func isPrime(_ p: Int) -> Bool {
  if p <= 1 { return false }
  if p <= 3 { return true }
  for i in 2...Int(sqrtf(Float(p))) {
    if p % i == 0 { return false }
  }
  return true
}
