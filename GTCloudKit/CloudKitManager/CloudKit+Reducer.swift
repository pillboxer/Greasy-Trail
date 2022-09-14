//
//  CloudKit+Reducer.swift
//  GTCloudKit
//
//  Created by Henry Cooper on 13/09/2022.
//

import ComposableArchitecture

private struct TimerID: Hashable {}

public let cloudKitReducer = Reducer<CloudKitState, CloudKitAction, CloudKitEnvironment> { state, action, environment in
    switch action {
    case .start(let date):
        return .run { send in await send(.fetchSongs(date)) }
    case .fetchSongs(let date):
        state.downloadingRecordType = .song
        return .run(operation: { send in
            for try await event in environment.client.fetchSongs(date) {
                switch event {
                case .updateProgress(let progress, let type):
                    await send(.cloudKitClient(.success(.updateProgress(progress, type))), animation: .default)
                case .completeFetch(let newValues):
                    await send(.fetchAlbums(date, newValues), animation: .default)
                }
            }
        }, catch: { error, send in
           await send(.cloudKitClient(.failure(error)))
        })
    case .fetchAlbums(let date, let newValues):
        state.downloadingRecordType = .album
        return .run { send in
            for try await event in environment.client.fetchAlbums(date) {
                switch event {
                case .updateProgress(let progress, let type):
                    await send(.cloudKitClient(.success(.updateProgress(progress, type))), animation: .default)
                case .completeFetch(let newAlbums):
                    let newValues = newAlbums ? newAlbums : newValues
                    await send(.fetchPerformances(date, newValues), animation: .default)
                }
            }
        }
    case .fetchPerformances(let date, let newValues):
        state.downloadingRecordType = .performance
        return .run { send in
            for try await event in environment.client.fetchPerformances(date) {
                switch event {
                case .updateProgress(let progress, let type):
                    await send(.cloudKitClient(.success(.updateProgress(progress, type))), animation: .default)
                case .completeFetch(let newPerformances):
                    let newValues = newPerformances ? newPerformances : newValues
                    await send(.cloudKitClient(.success(.completeFetch(newValues: newValues))), animation: .default)
                }
            }
        }
    case .cloudKitClient(.success(.updateProgress(let double, let song))):
        state.mode = .downloading(progress: double, song)
        return .none
    case .cloudKitClient(.success(.completeFetch(let newValues))):
        state.mode = .downloaded
        state.downloadingRecordType = nil
        state.lastFetchDate = newValues ? Date() : state.lastFetchDate
        return Effect.timer(id: TimerID(), every: 3, on: DispatchQueue.main.eraseToAnyScheduler())
            .animation()
          .map { _ in .completeDownload }
    case .cloudKitClient(.failure(let error)):
        state.mode = .downloadFailed(.init(error))
        return .none
    case .completeDownload:
        state.mode = .notDownloaded
        return .cancel(id: TimerID())
    }
}
