//
//  ResultPerformancesView.swift
//  Dylan
//
//  Created by Henry Cooper on 06/07/2022.
//

import SwiftUI

struct TwoColumnTableView: View {
    
    let models: [TableDisplayModel]
    @Binding var songDisplayModel: SongDisplayModel?
    @EnvironmentObject var formatter: Formatter
    @Binding var nextSearch: Search?
    @Binding var currentViewType: ResultView.ResultViewType
    @State private var selection: String?
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        currentViewType = .songOverview
                    }
                Spacer()
                Text(songDisplayModel?.title ?? "")
                Spacer()
            }
            Table(models, selection: $selection) {
                TableColumn(column1Header) { model in
                    Text(model.column1Value)
                        .gesture(TapGesture(count: 2).onEnded {
                            selection = model.id
                            nextSearch = (nextSearchType == .album ? model.column1Value : String(model.column2Value), nextSearchType)
                            self.songDisplayModel = nil
                            
                        })
                        .simultaneousGesture(TapGesture()
                            .onEnded {
                                self.selection = model.id
                            })
                }
                TableColumn(column2Header) { model in
                    Text(formatter.dateString(of: model.column2Value))
                }
            }
        }
        .padding()
    }
}

extension TwoColumnTableView {
    
    var column1Header: String {
        switch currentViewType {
        case .performances:
            return "Venue"
        case .albums:
            return "Title"
        default:
            return ""
        }
    }
    
    var column2Header: String {
        switch currentViewType {
        case .performances:
            return "Date"
        case .albums:
            return "Release Date"
        default:
            return ""
        }
    }
    
    var nextSearchType: DylanSearchType {
        switch currentViewType {
        case .albums:
            return .album
        default:
            return .performance
        }
    }
}
