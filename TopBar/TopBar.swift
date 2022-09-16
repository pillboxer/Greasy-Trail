//
//  TopBar.swift
//  TopBar
//
//  Created by Henry Cooper on 16/09/2022.
//

import ComposableArchitecture
import GTCloudKit
import SwiftUI
import Core

public struct TopBarState: Equatable {
    public var showingCloudKitError = false
    public var cloudKit: CloudKitState
    
    var mode: Mode? {
        cloudKit.mode
    }
    
    public init(cloudKitState: CloudKitState,
                showingCloudKitError: Bool) {
        self.cloudKit = cloudKitState
        self.showingCloudKitError = showingCloudKitError
    }
}

enum TopBarViewAction {
    case toggleCloudKitError
    case refetch(Date?)
}

public enum TopBarAction: Equatable {
    case toggleCloudKitError
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
    case .toggleCloudKitError:
        state.showingCloudKitError.toggle()
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
            case .downloadFailed(let error):
                DownloadFailedView(viewStore: viewStore, error: error)
            case .downloading(progress: let progress, let type):
                DownloadingView(type: type, progress: progress)
            case .downloaded, .uploaded:
                OperationSuccessView()
            case .uploading(progress: let progress):
                UploadingView(progress: progress)
            default:
                EmptyView()
            }
        }
        .onDisappear {
            if viewStore.state.showingCloudKitError {
                viewStore.send(.toggleCloudKitError)
            }
        }
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
        case .toggleCloudKitError:
            self = .topBar(.toggleCloudKitError)
        case .refetch(let date):
            self = .cloudKit(.start(date: date))
        }
    }
}
