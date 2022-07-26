//
//  SpellingResolverManager.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import Combine
import Foundation
import CoreData
import os

// FIXME: TESTS
class SpellingResolverManager: ObservableObject {
    
    private let container: NSPersistentContainer
    private let cloudKitManager: CloudKitManager
    
    @Published var key: String = ""
    @Published var value: String = ""
    
    init(cloudKitManager: CloudKitManager,
         container: NSPersistentContainer = PersistenceController.shared.container) {
        self.cloudKitManager = cloudKitManager
        self.container = container
    }
    
    func save(key: String, value: String, type: DylanRecordType) async -> Bool {
        os_log("Attempting to save key %{public}@ and value %{public}@", log: Log_SpellingResolver, key, value)
        self.key = ""
        self.value = ""
        let context = container.newBackgroundContext()
        var appMetadata: AppMetadata!
        context.syncPerform { () -> Void in
            guard let metadata = context.fetchAndWait(AppMetadata.self, with: .misspellings).first,
                  let data = metadata.file,
                  var misspellings = try? data.decoded() as Misspellings else {
                os_log("Could not find metadata", log: Log_SpellingResolver)
                return
            }
                        
            switch type {
            case .song:
                misspellings.songs[key] = value
            default:
                fatalError()
            }
            
            guard let encoded = try? misspellings.encoded() else {
                return
            }
            
            metadata.file = encoded
            appMetadata = metadata
        }
        context.syncSave()
        let didUpload = await cloudKitManager.upload(appMetadata)
        return didUpload
    }
}
