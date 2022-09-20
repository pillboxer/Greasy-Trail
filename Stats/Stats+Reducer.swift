import ComposableArchitecture
import CoreData
import GTCoreData
import Search

public let statsFeatureReducer: Reducer<StatsState, StatsFeatureAction, SearchEnvironment> =
Reducer.combine(
    statsReducer.pullback(
        state: \.self,
        action: /StatsFeatureAction.stats,
        environment: { _ in ()}),
    searchReducer.pullback(
        state: \.search,
        action: /StatsFeatureAction.search,
        environment: { $0 })
)

public let statsReducer = Reducer<StatsState, StatsAction, Void> { state, action, _ in
    switch action {
    case .selectDisplayedView(let displayedView):
        state.displayedView = displayedView
        return .none
    case .fetchMissingLBNumbers:
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
        state.missingLBNumbers = lbNumbers
        state.isFetchingMissingLBCount = false
        return Effect(value: StatsAction.selectDisplayedView(.missingLBs))
    }
}
