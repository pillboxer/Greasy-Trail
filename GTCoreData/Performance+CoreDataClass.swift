import Foundation
import CoreData
import Core

@objc(Performance)
public class Performance: NSManagedObject {
    
    public var dateFormat: PerformanceDateFormat? {
        guard let dateFormatString = dateFormatString else {
            return nil
        }
        return PerformanceDateFormat(rawValue: dateFormatString)
    }

}
