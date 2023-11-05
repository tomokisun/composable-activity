import SwiftUI
import ComposableArchitecture

struct ContentReducer: Reducer {
  struct Destination: Reducer {
    enum State: Equatable {
      case activity(ActivityReducer.State)
    }
    enum Action: Equatable {
      case activity(ActivityReducer.Action)
    }
    var body: some Reducer<State, Action> {
      Scope(state: /State.activity, action: /Action.activity, child: ActivityReducer.init)
    }
  }

  struct State: Equatable {
    @PresentationState var destination: Destination.State?
  }

  enum Action: Equatable {
    case okayButtonTapped
    case destination(PresentationAction<Destination.Action>)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .okayButtonTapped:
        let url = URL(string: "https://apple.com")!
        state.destination = .activity(
          ActivityReducer.State(url: url)
        )
        return .none

      case let .destination(.presented(.activity(.onCompletion(completion)))):
        guard completion.result else { return .none }
        print("OK")
        return .none

      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }
}

struct ContentView: View {
  let store: StoreOf<ContentReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 25) {
        Text("Apple")
          .font(.largeTitle)
        
        Button("Okay") {
          store.send(.okayButtonTapped)
        }
      }
      .padding()
      .sheet(
        store: store.scope(state: \.$destination, action: ContentReducer.Action.destination),
        state: /ContentReducer.Destination.State.activity,
        action: ContentReducer.Destination.Action.activity
      ) { store in
        ActivityView(store: store)
          .presentationDetents([.medium, .large])
      }
    }
  }
}
