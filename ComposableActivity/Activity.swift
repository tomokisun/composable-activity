import SwiftUI
import ComposableArchitecture

struct ActivityReducer: Reducer {
  struct Completion: Equatable {
    let activityType: UIActivity.ActivityType?
    let result: Bool
  }
  struct State: Equatable {
    let url: URL
  }
  enum Action: Equatable {
    case onCompletion(Completion)
  }
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    return .none
  }
}

struct ActivityView: View {
  let store: StoreOf<ActivityReducer>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      UIActivityView(
        activityItems: [viewStore.url],
        applicationActivities: nil
      ) { activityType, result, _, error in
        store.send(
          .onCompletion(
            ActivityReducer.Completion(
              activityType: activityType,
              result: result
            )
          )
        )
      }
    }
  }
  
  struct UIActivityView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    let activityViewController: UIActivityViewController
    
    init(
      activityItems: [Any],
      applicationActivities: [UIActivity]?,
      completionWithItemsHandler: @escaping UIActivityViewController.CompletionWithItemsHandler
    ) {
      let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
      activityViewController.completionWithItemsHandler = completionWithItemsHandler
      self.activityViewController = activityViewController
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
      activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
  }
}
