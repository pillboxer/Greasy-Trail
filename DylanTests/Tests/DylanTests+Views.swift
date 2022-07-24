//
//  DylanTests+Views.swift
//  DylanTests
//
//  Created by Henry Cooper on 24/07/2022.
//

@testable import Greasy_Trail
import XCTest

extension DylanTests {
    
    func testViews() {
        
        let resultView = ResultView(nextSearch: .constant(nil), currentViewType: .songOverview)
        
        let resultSongOverview = ResultSongOverviewView(model: .constant(nil),
                                                        currentViewType: .constant(.songOverview),
                                                        nextSearch: .constant(nil))
        let resultAlbumOverview = ResultAlbumOverviewView(model: .constant(nil),
                                                          nextSearch: .constant(nil))
        let resultPerformanceOverview = ResultPerformanceOverviewView(model: .constant(nil),
                                                                      nextSearch: .constant(nil),
                                                                      currentViewType: .constant(.performanceOverview))
        
        let uploadView = UploadView(recordType: .performance, onTap: {_ in})
        let performanceUploadView = PerformanceAddingView(completion: {_ in })
        
        let listRowView = ListRowView(headline: "", onTap: {})
        
        let songsListView = SongsListView(songs: [], onTap: {_ in })
        let albumsListView = AlbumsListView(albums: [], onTap: {_ in })
        let performancesListView = PerformancesListView(performances: [], onTap: {_ in })
        let lbsListView = LBsListView(lbs: [], onTap: { _ in })
        
        let searchingView = SearchingView()
        let failureView = CloudKitFailureView(error: "")
        
        _ = resultView.body
        _ = resultSongOverview.body
        _ = resultAlbumOverview.body
        _ = resultPerformanceOverview.body
        _ = uploadView.body
        _ = performanceUploadView.body
        _ = listRowView.body
        _ = songsListView.body
        _ = albumsListView.body
        _ = performancesListView.body
        _ = lbsListView.body
        _ = searchingView.body
        
        _ = failureView.body
        
        XCTAssert(true)
    }
    
}
