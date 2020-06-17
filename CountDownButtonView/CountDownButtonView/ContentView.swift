// 

import SwiftUI
import ComposableArchitecture

struct CountDownButtonState: Equatable {
  var countDownMaxBound: Int
  var countDownMinBound: Int
  var buttonEnabled: Bool = true
  var countDownTime: Int?
}

enum CountDownButtonAction: Equatable {
  case countDownButtonTapped
  case updateCountDownTime
}

struct CountDownButtonEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let countDownButtonReducer = Reducer<
  CountDownButtonState, CountDownButtonAction, CountDownButtonEnvironment
> { state, action, environment in
  struct CountDownButtonTimerId: Hashable {}
  switch action {
  case .countDownButtonTapped:
    state.buttonEnabled = false
    state.countDownTime = nil
    return Effect
      .timer(id: CountDownButtonTimerId(), every: 1, on: environment.mainQueue)
      .map { _ in CountDownButtonAction.updateCountDownTime }
    
  case .updateCountDownTime:
    if let countDown = state.countDownTime {
      state.countDownTime = countDown - 1
    } else {
      state.countDownTime = state.countDownMaxBound - 1
    }
    if let countDownTime = state.countDownTime, countDownTime == state.countDownMinBound {
      state.buttonEnabled = true
      return .cancel(id: CountDownButtonTimerId())
    }
    return .none
  }
}
.debug()

struct ContentView: View {
  let store: Store<CountDownButtonState, CountDownButtonAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Button(
        action: {
          viewStore.send(.countDownButtonTapped)
      }) {
        Text(viewStore.buttonEnabled ? "Log In" : "\(viewStore.countDownTime ?? viewStore.countDownMaxBound)s 后点击重发")
          .foregroundColor(.white)
          .fontWeight(.semibold)
          .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
          .background(
            Capsule()
              .foregroundColor(viewStore.buttonEnabled ? .blue : .gray)
          )
      }
      .disabled(!viewStore.buttonEnabled)
    }
  }
}


