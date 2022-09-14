//
//  Downloading.swift
//  Downloading
//
//  Created by Henry Cooper on 14/09/2022.
//

import ComposableArchitecture
import GTCloudKit
import SwiftUI
import Core
import UI

public struct DownloadingState: Equatable {
    public var showingCloudKitError = false
    public var cloudKit: CloudKitState
    
    var mode: Mode {
        cloudKit.mode
    }
    
    public init(cloudKitState: CloudKitState,
                showingCloudKitError: Bool) {
        self.cloudKit = cloudKitState
        self.showingCloudKitError = showingCloudKitError
    }
}

private enum DownloadingViewAction {
    case toggleCloudKitError
    case refetch(Date?)
}

public enum DownloadingAction: Equatable {
    case toggleCloudKitError
}

public enum DownloadingFeatureAction {
    case downloading(DownloadingAction)
    case cloudKit(CloudKitAction)
}

public let downloadingFeatureReducer: Reducer<DownloadingState, DownloadingFeatureAction, CloudKitEnvironment> =
Reducer.combine(
    downloadingViewReducer.pullback(
        state: \.self,
        action: /DownloadingFeatureAction.downloading,
        environment: { _ in ()}),
    cloudKitReducer.pullback(
        state: \.cloudKit,
        action: /DownloadingFeatureAction.cloudKit,
        environment: { $0 })
    )

public let downloadingViewReducer = Reducer<DownloadingState, DownloadingAction, Void> { state, action, _ in
    switch action {
    case .toggleCloudKitError:
        state.showingCloudKitError.toggle()
        return .none
    }
}

public struct DownloadingView: View {
    
    @UserDefaultsBacked(key: "last_fetch_date") var lastFetchDate: Date?
    let store: Store<DownloadingState, DownloadingFeatureAction>
    @ObservedObject private var viewStore: ViewStore<DownloadingState, DownloadingViewAction>
    
    public init(store: Store<DownloadingState, DownloadingFeatureAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: { $0 }, action: DownloadingFeatureAction.init))
    }
    
    public var body: some View {
            Group {
                switch viewStore.mode {
                case .downloadFailed(let error):
                    HStack {
                        Text(viewStore.state.showingCloudKitError ?
                             String(describing: error) : String(formatted: "cloud_kit_fetch_error"))
                        .font(.caption)
                        Spacer()
                        PlainOnTapButton(systemImage: "arrow.clockwise.circle.fill") {
                            viewStore.send(.refetch(lastFetchDate))
                        }
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.green)
                        PlainOnTapButton(systemImage: "exclamationmark.triangle.fill") {
                            let pasteboard = NSPasteboard.general
                            pasteboard.declareTypes([.string], owner: nil)
                            pasteboard.setString(String(describing: error), forType: .string)
                            viewStore.send(.toggleCloudKitError)
                        }
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.black, .black, .yellow)
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: 12, height: 12)
                    }
                case .downloading(progress: let progress, let type):
                    VStack {
                        HStack {
                            Image(systemName: type.bridged.imageName)
                                .resizable()
                                .aspectRatio(contentMode: ContentMode.fit)
                                .frame(width: 12, height: 12)
                            Text(String(formatted: "cloud_kit_feching_in_progress", args: type.rawValue.capitalized))
                                .font(.caption)
                            Spacer()
                            ProgressView(value: progress)
                                .frame(width: 256)
                            Text(String(Int(progress * 100)) + "%")
                                .font(.caption)
                                .frame(width: 36)
                        }
                    }
                case .downloaded:
                    HStack {
                        Text("cloud_kit_fetch_success")
                            .font(.caption)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(.green)
                            .aspectRatio(contentMode: ContentMode.fit)
                            .frame(width: 12, height: 12)
                    }
                case .notDownloaded:
                    EmptyView()
                }
            }
            .onDisappear {
                viewStore.send(.toggleCloudKitError)
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

private extension DownloadingFeatureAction {
    init(_ action: DownloadingViewAction) {
        switch action {
        case .toggleCloudKitError:
            self = .downloading(.toggleCloudKitError)
        case .refetch(let date):
            self = .cloudKit(.start(date: date))
        }
    }
}
