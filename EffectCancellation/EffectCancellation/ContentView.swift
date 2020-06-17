// 

import SwiftUI
import ComposableArchitecture
import Combine
import ActivityIndicator

private let readMe = """
This application demonstrates how to handle long-living effects, for example notifications from \
Notification Center.

Run this application in the simulator, and take a few screenshots by going to \
*Device › Screenshot* in the menu, and observe that the UI counts the number of times that \
happens.

Then, navigate to another screen and take screenshots there, and observe that this screen does \
*not* count those screenshots.
"""

struct EffectCancellationState: Equatable {
  var count = 0
  var currentTrivia: String?
  var isTriviaRequestInFlight = false
}

enum EffectCancellationStateAction: Equatable {
  case cancelButtonTapped
  case stepperChanged(Int)
  case triviaButtonTapped
  case triviaResponse(Result<String, TriviaApiError>)
}

struct TriviaApiError: Error, Equatable {}

struct EffectsCancellationEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var trivia: (Int) -> Effect<String, TriviaApiError>
  
  static let live = EffectsCancellationEnvironment(
    mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
    trivia: liveTrivia(for:)
  )
}

let effectsCancellationReducer = Reducer<
  EffectCancellationState, EffectCancellationStateAction, EffectsCancellationEnvironment
  > { state, action, environment in
    struct TriviaRequestId: Hashable {}
    
    switch action {
    case .cancelButtonTapped:
      state.isTriviaRequestInFlight = false
      return .cancel(id: TriviaRequestId())
    case let .stepperChanged(value):
      state.count = value
      state.currentTrivia = nil
      state.isTriviaRequestInFlight = false
      return .cancel(id: TriviaRequestId())
    case .triviaButtonTapped:
      state.currentTrivia = nil
      state.isTriviaRequestInFlight = true
      return environment.trivia(state.count)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(EffectCancellationStateAction.triviaResponse)
        .cancellable(id: TriviaRequestId())
    case let .triviaResponse(.success(trivial)):
      state.currentTrivia = trivial
      state.isTriviaRequestInFlight = false
      return .none
    case .triviaResponse(.failure):
      state.isTriviaRequestInFlight = false
      return .none
    }
}

struct ContentView: View {
  let store: Store<EffectCancellationState, EffectCancellationStateAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        Form {
          Section(
            header: Text(readMe).font(.caption),
            footer: Button("Number facts provided by numbersapi.com") {
              UIApplication.shared.open(URL(string: "http://numbersapi.com")!)
            }
          ) {
            Stepper(
              value: viewStore.binding(
                get: { $0.count },
                send: EffectCancellationStateAction.stepperChanged
              )
            ) {
              Text("\(viewStore.count)")
            }
            if viewStore.isTriviaRequestInFlight {
              HStack {
                Button("Cancel") { viewStore.send(.cancelButtonTapped) }
                Spacer()
                ActivityIndicator()
              }
            } else {
              Button("Number fact") { viewStore.send(.triviaButtonTapped) }
                .disabled(viewStore.isTriviaRequestInFlight)
            }
            
            viewStore.currentTrivia.map {
              Text($0)
                .padding([.top, .bottom], 8)
            }
          }
        }
        .navigationBarTitle("Effects Cancellations")
      }
    }
  }
}

private func liveTrivia(for n: Int) -> Effect<String, TriviaApiError> {
  URLSession.shared
    .dataTaskPublisher(for: URL(string: "http://numbersapi.com/\(n)/trivia")!)
    .map { data, _ in String(decoding: data, as: UTF8.self) }
    .catch { _ in
      Just("\(n) is a good number brent")
        .delay(for: 1, scheduler: DispatchQueue.main)
    }
    .mapError { _ in TriviaApiError() }
    .eraseToEffect()
}
