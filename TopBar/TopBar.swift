import ComposableArchitecture
import GTCloudKit
import SwiftUI
import Core

public struct TopBarState: Equatable {
    public var showingError: Bool
    public var cloudKit: CloudKitState
    public var isFetchingLogs: Bool
    
    var mode: Mode? {
        get {
            cloudKit.mode
        }
        set {
            cloudKit.mode = newValue
        }
    }
    
    public init(cloudKitState: CloudKitState,
                showingError: Bool,
                isFetchingLogs: Bool) {
        self.cloudKit = cloudKitState
        self.isFetchingLogs = isFetchingLogs
        self.showingError = showingError
    }
}

enum TopBarViewAction {
    case toggleError
    case refetch(Date?)
    case reset
}

public enum TopBarAction: Equatable {
    case toggleError
    case reset
}

public enum TopBarFeatureAction {
    case topBar(TopBarAction)
    case cloudKit(CloudKitAction)
}

public let topBarFeatureReducer: Reducer<TopBarState, TopBarFeatureAction, CloudKitEnvironment> =
Reducer.combine(
    topBarReducer.pullback(
        state: \.self,
        action: /TopBarFeatureAction.topBar,
        environment: { _ in ()}),
    cloudKitReducer.pullback(
        state: \.cloudKit,
        action: /TopBarFeatureAction.cloudKit,
        environment: { $0 })
)

public let topBarReducer = Reducer<TopBarState, TopBarAction, Void> { state, action, _ in
    switch action {
    case .toggleError:
        state.showingError.toggle()
        return .none
    case .reset:
        state.showingError = false
        state.mode = nil
        return .none
    }
}

public struct TopBarView: View {
    
    let store: Store<TopBarState, TopBarFeatureAction>
    @ObservedObject private var viewStore: ViewStore<TopBarState, TopBarViewAction>
    
    public init(store: Store<TopBarState, TopBarFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { $0 }, action: TopBarFeatureAction.init))
    }
    
    public var body: some View {
        Group {
            switch viewStore.mode {
            case .operationFailed(let error):
                OperationFailedView(viewStore: viewStore, error: error)
            case .downloading(progress: let progress, let type):
                DownloadingView(type: type, progress: progress)
            case .downloaded, .uploaded:
                OperationSuccessView()
            case .uploading(progress: let progress):
                UploadingView(progress: progress)
            case .fetchingLogs:
                FetchingLogsView()
            default:
                EmptyView()
            }
        }
        .font(.caption)
        .frame(maxHeight: 36)
    }
}

extension DylanRecordType {
    
    var bridged: DylanWork {
        switch self {
        case .song:
            return .songs
        case .performance:
            return .performances
        case .album:
            return .albums
        default:
            fatalError()
        }
    }
}

extension TopBarFeatureAction {
    init(_ action: TopBarViewAction) {
        switch action {
        case .toggleError:
            self = .topBar(.toggleError)
        case .refetch(let date):
            self = .cloudKit(.start(date: date))
        case .reset:
            self = .topBar(.reset)
        }
    }
}
