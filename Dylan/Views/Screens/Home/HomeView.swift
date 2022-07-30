//
//  HomeView.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 18/07/2022.
//

import SwiftUI

enum SidebarSection: String, CaseIterable {
    case songs = "Song"
    case album = "Album"
    case performances = "Performance"
}

struct HomeView: View {

    let fetchingType: DylanRecordType?
    var progress: Double? = 0
    @State var recordTypeToAdd: DylanRecordType?

    @EnvironmentObject private var cloudKitManager: CloudKitManager

    var body: some View {
        NavigationView {
            VStack {
                List(DylanRecordType.displayedTypes, id: \.self) { item in

                    HStack {
                        SidebarListRowView(recordType: item,
                                           isFetching: fetchingType == item,
                                           progress: progress) {
                            recordTypeToAdd = item
                        }
                    }
                    .padding(4)
                }
                if let recordType = recordTypeToAdd {
                    // FIXME: UPloade view model
                    UploadView(recordType: recordType) { model in
                        Task {
                            await cloudKitManager.upload(model)
                        }
                    }
                }
                SearchView()
                    .padding()
            }
        }
    }
}
