import SwiftUI
import ComposableArchitecture

@main
struct ComposableActivityApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: ContentReducer.State(), reducer: {
          ContentReducer()
            ._printChanges()
        })
      )
    }
  }
}
