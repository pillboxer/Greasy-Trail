import SwiftUI
import GTFormatter
import UI
import Model
import ComposableArchitecture
import PerformancesList
import Search
import Core

public struct ResultSongOverviewView: View {
    
    let store: Store<SearchState, SearchAction>
    private let formatter = GTFormatter.Formatter()
    private let model: SongDisplayModel
    
    public init(store: Store<SearchState, SearchAction>,
                model: SongDisplayModel) {
        self.model = model
        self.store = store
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text(model.title)
                        .font(.headline)
                        .padding(.bottom, 4)
                    Group {
                        if let performances = model.performances, !performances.isEmpty {
                            performances.count == 1
                            ? Text(tr("performance_count_singular"))
                            : Text(tr("performance_count", String(performances.count)))
                        } else {
                            Text("performances_list_empty")
                        }
                    }
                    .font(.caption)
                }
                Spacer()
            }
            if let performances = model.performances, !performances.isEmpty {
                PerformancesListView(performances: performances, store: store.scope(state: {
                    $0.model
                }, action: {
                    $0
                }))
            }
            Spacer()
            HStack {
                Spacer()
                Text(tr("song_author", model.author))
            }
            .font(.caption)
        }
        .padding()
    }

}
