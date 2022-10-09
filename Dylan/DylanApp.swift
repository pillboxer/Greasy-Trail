import SwiftUI
import ComposableArchitecture
import Search
import Core
import GTCloudKit
import GTCoreData

@main
struct DylanApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
        viewStore = ViewStore(
            appStore.stateless.scope(
                state: { $0 },
                action: { .commandMenu($0) }))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: appStore)
                .task {
                    ViewStore(appStore).send(.cloudKit(.subscribeToDatabases))
                    ViewStore(appStore).send(.payments(.payments(.start)))
                    ViewStore(appStore).send(.cloudKit(.fetchAdminMetadata))
                    ViewStore(appStore).send(.cloudKit(.start(date: lastFetchDate)))
                }
        }.commands {
            CommandGroup(replacing: .newItem, addition: {})
            CommandGroup(after: .help) {
                Button("developer_menu_bug_report") {
                    viewStore.send(.copyLogs)
                }
                Button("delete_menu_button") {
                    ViewStore(appStore).send(.commandMenu(.toggleDeleteAlert))
                }
            }
        }
    }
}
