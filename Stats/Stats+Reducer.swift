import ComposableArchitecture
import CoreData
import GTCoreData
import Search
import Core
import os

let logger = Logger(subsystem: .subsystem, category: "Stats")

public let statsFeatureReducer: Reducer<StatsState, StatsFeatureAction, SearchEnvironment> =
Reducer.combine(
    statsReducer.pullback(
        state: \.self,
        action: /StatsFeatureAction.stats,
        environment: { _ in ()}),
    searchReducer.pullback(
        state: \.searchState,
        action: /StatsFeatureAction.search,
        environment: { $0 })
)

public let statsReducer = Reducer<StatsState, StatsAction, Void> { state, action, _ in
    switch action {
    case .selectDisplayedView(let displayedView):
        state.displayedView = displayedView
        return .none
    case .fetchMissingLBNumbers:
        logger.log("Fetching missing LB numbers")
        state.isFetchingMissingLBCount = true
        return .future { promise in
            let context = PersistenceController.shared.newBackgroundContext()
            let request: NSFetchRequest<Performance> = Performance.fetchRequest()
            context.perform {
                do {
                    let objects = try context.fetch(request)
                    let allLBs = objects
                        .compactMap { $0.lbNumbers }
                        .flatMap { Set($0) }
                    let missingLBS = (1...15599).filter { !allLBs.contains($0) }
                    promise(.success(.completeFetch(missingLBS)))
                } catch let error {
                    fatalError()
                }
            }
        }
        .receive(on: DispatchQueue.main.eraseToAnyScheduler())
        .eraseToEffect()
    case .completeFetch(let lbNumbers):
        logger.log("Completed fetch with \(lbNumbers, privacy: .public) LB numbers")
        state.missingLBNumbers = lbNumbers
        state.isFetchingMissingLBCount = false
        return Effect(value: StatsAction.selectDisplayedView(.missingLBs))
    }
}
