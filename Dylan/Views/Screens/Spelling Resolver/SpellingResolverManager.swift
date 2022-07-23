//
//  SpellingResolverManager.swift
//  Greasy Trail
//
//  Created by Henry Cooper on 23/07/2022.
//

import Combine
import Foundation

class SpellingResolverManager: ObservableObject {
    
    private let container = PersistenceController.shared
    private let cloudKitManager: CloudKitManager
    
    @Published var key: String = ""
    @Published var value: String = ""
    
    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    
    func save(key: String, value: String, type: DylanRecordType) async -> Bool {
        self.key = ""
        self.value = ""
        let context = container.newBackgroundContext()
        var appMetadata: AppMetadata?
        let didSave = context.syncPerform { () -> Bool in
            guard let metadata = context.fetchAndWait(AppMetadata.self, with: .misspellings).first,
                  let data = metadata.file,
                  var misspellings = try? data.decoded() as Misspellings else {
                return false
            }
            
            appMetadata = metadata
            
            switch type {
            case .song:
                misspellings.songs[key] = value
            default:
                fatalError()
            }
            
            guard let encoded = try? misspellings.encoded() else {
                return false
            }
            
            metadata.file = encoded
            context.saveWithTry()
            return true
        }
        
        guard let appMetadata = appMetadata else {
            return false
        }

        let didUpload = await cloudKitManager.upload(appMetadata)
        return didSave && didUpload
    }
}
