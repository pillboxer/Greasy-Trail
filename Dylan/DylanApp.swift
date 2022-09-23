import SwiftUI
import ComposableArchitecture
import Search
import Core
import GTCloudKit

@main
struct DylanApp: App {
    
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    @ObservedObject private var viewStore: ViewStore<Void, CommandMenuAction>
    
    let appStore = Store(initialState: AppState(),
                         reducer: appReducer,
                         environment: AppEnvironment(search: Searcher().search,
                                                     randomSong: Searcher().randomSong,
                                                     randomAlbum: Searcher().randomAlbum,
                                                     randomPerformance: Searcher().randomPerformance,
                                                     cloudKitClient: .live))
    
    init() {
        viewStore = ViewStore(appStore.stateless.scope(state: { $0 }, action: { .commandMenu($0) }))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: appStore)
                .onAppear {
                    ViewStore(appStore).send(.cloudKit(.start(date: lastFetchDate)))
                }
        } .commands {
            CommandGroup(after: .help) {
                Button("devloper_menu_bug_report") {
                    viewStore.send(.copyLogs)
                }
            }
        }
    }
}
